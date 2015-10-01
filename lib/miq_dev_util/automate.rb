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

    private

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
