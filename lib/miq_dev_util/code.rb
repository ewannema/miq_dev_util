# The Code class is a container for miscellaneous methods that a developer may
# find useful. The focus is on standard Ruby oriented tasks that could apply
# outside of the ManageIQ environment.

class MiqDevUtil::Code
  # Perform a deep copy on objects that support marshalling.
  def self.deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end
end
