class MiqDevUtil::Logger
  def initialize(evm, method_name)
    @evm = evm
    @method_name = method_name

    @dump_log_level = :info
  end

  def log(level, message)
    @evm.log(level, "#{@_method_name} - #{message}")
  end

  def dump_attributes(my_object, my_object_name)
    if my_object.respond_to?("attributes")
      self.log(@dump_log_level, "Begin #{my_object_name}.attributes")
      my_object.attributes.sort.each { |k, v| $evm.log(:info, "#{my_object_name} Attribute - #{k}: #{v}")}
      self.log(@dump_log_level, "End #{my_object_name}.attributes")
      self.log(@dump_log_level, "")
    else
      self.log(@dump_log_level, "No attributes for #{my_object_name}")
    end
  end

  def dump_associations(my_object, my_object_name)
    if my_object.respond_to?("associations")
      self.log(@dump_log_level, "Begin #{my_object_name}.associations")
      my_object.associations.sort.each { |a| $evm.log(:info, "#{my_object_name} Association - #{a}")}
      self.log(@dump_log_level, "End #{my_object_name}.associations")
      self.log(@dump_log_level, "")
    else
      self.log(@dump_log_level, "No associations for #{my_object_name}")
    end
  end

  def dump_virtual_columns(my_object, my_object_name)
    if my_object.respond_to?("virtual_columns")
      self.log(@dump_log_level, "Begin #{my_object_name}.virtual_columns")
      my_object.virtual_column_names.sort.each { |vcn| $evm.log(:info, "#{my_object_name} Virtual Column - #{vcn}")}
      self.log(@dump_log_level, "End #{my_object_name}.virtual_columns")
      self.log(@dump_log_level, "")
    else
      log(@dump_log_level, "No virtual_columns for #{my_object_name}")
    end
  end

  def dump_info(my_object, my_object_name)
    self.dump_attributes(my_object, my_object_name)
    self.dump_associations(my_object, my_object_name)
    self.dump_virtual_columns(my_object, my_object_name)
  end

  def dump_root()
    self.dump_info(@evm.root, "$evm.root")
  end
end

