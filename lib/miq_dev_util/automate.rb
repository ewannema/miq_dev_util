module MiqDevUtil
  # The Automate class is intended to hold methods that are useful when
  # interacting with the ManageIQ automate system directly.
  class Automate
    def initialize(evm)
      @evm = evm
    end

    # Instantiate an automate instance at path or raise an exception with the
    # message provided if the instantiation returns nil (not found).
    def instantiate_or_raise(path, message)
      object = @evm.instantiate(path)
      if object.nil?
        raise message
      end

      object
    end

    # This is a hacky workaround used to get an instance without executing the
    # methods on it. It fails if a message is passed in the path or if the
    # message field on the any of the methods are *.
    def get_instance_with_attributes(path)
      if path =~ /#/
        raise "Does not work with messages in the path."
      end
      fake_message = "callingWithAFakeMessage"
      empty_instance = @evm.instantiate("#{path}##{fake_message}")
      instance_name = empty_instance.name
      @evm.instance_get(instance_name)
    end

    # Condense multiple types of VM lookups into one call. This is useful when
    # making an Automate method generic enough to be used during provisioning,
    # with a custom button, or as a catalog item.
    #
    # Lookup methods used and their order can be overridden by specifying
    # :lookup_order
    #
    # The dialog name that may hold the miq ID is specified via :dialog_name
    def resolve_vm(lookup_order: [:rootvm, :dialog_id, :provision],
                   dialog_name: 'dialog_target_server')

      vm = nil
      lookup_order.each do |lu_method|
        vm = vm_lookup_by(lu_method, dialog_name)

        # If we found a VM we can stop looking
        break unless vm.nil?
      end

      vm
    end

    # A wrapper to handle MIQ 5.4 which does not have this built in and 5.5+
    # which does.
    def create_automation_request(options, userid = 'admin', auto_approve = false)
      unless service_method_defined?(:create_automation_request)
        backport_create_automation_request
      end

      @evm.execute('create_automation_request', options, userid, auto_approve)
    end

    # Wait until the automation request shows as finished.
    # Wait at most max_wait seconds.
    # Check the status ever poll_interval seconds.
    def wait_for_automation_request(request, options = {})
      max_wait = options['max_wait'] || 600
      poll_interval = options['poll_interval'] || 15

      start_time = Time.now

      while (Time.now - start_time) < max_wait
        request = $evm.vmdb(:automation_request).find(request.id)
        return request if request['request_state'] == 'finished'
        sleep(poll_interval)
      end

      raise 'Automation request wait time exceeded.'
    end

    # Create an automation request that will run in the same zone as the VM's
    # EMS. Also set some values to make this have similar data to that which
    # a method responding to a button press would have.
    def zone_aware_vm_automation_request(vm, options, userid = 'admin',
                                         auto_approve = false)
      options[:miq_zone] = vm.ext_management_system.zone_name
      options[:attrs] = {} if options[:attrs].nil?
      options[:attrs][:vm] = vm
      options[:attrs][:vm_id] = vm.id

      create_automation_request(options, userid, auto_approve)
    end

    private

    def service_method_defined?(method)
      @evm.execute(:instance_eval, "respond_to?(:#{method})")
    end

    def backport_create_automation_request
      @evm.execute(:class_eval, create_automation_request_definition)
    end

    # This is based on the MIQ 5.5 method, but changed regarding the user/userid
    # since the code in 5.4 uses a different value.
    def create_automation_request_definition
      <<-eos
        def self.create_automation_request(options, userid = "admin", auto_approve = false)
          MiqAeServiceModelBase.wrap_results(AutomationRequest.create_request(options, userid, auto_approve))
        end
      eos
    end

    def vm_lookup_by(lu_method, dialog_name = nil)
      case lu_method
      when :rootvm    then @evm.root['vm']
      when :dialog_id then vm_by_id(@evm.root[dialog_name])
      when :provision then provision_vm
      else fail "unknown lookup method #{lu_method}"
      end
    end

    def vm_by_id(vm_id)
      @evm.vmdb('vm_or_template', vm_id)
    rescue StandardError
      nil
    end

    def provision_vm
      return nil unless @evm.root['miq_provision'].respond_to?('vm')
      @evm.root['miq_provision'].vm
    end
  end
end
