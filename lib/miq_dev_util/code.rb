class MiqDevUtil::Code
  # Perform a deep copy on objects that support marshalling.
  def deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end
end
