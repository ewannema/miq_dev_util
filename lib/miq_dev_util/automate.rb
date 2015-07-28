class MiqDevUtil::Automate
  def initialize(evm)
    @evm = evm
  end

  def instantiate_or_exception(path, message)
    object = @evm.instantiate(path)
    if object.nil?
      raise message
    end

    object
  end
end

