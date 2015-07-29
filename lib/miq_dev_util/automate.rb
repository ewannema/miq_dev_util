# The Automate class is intended to hold methods that are useful when
# interacting with the ManageIQ automate system directly.

class MiqDevUtil::Automate

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
end

