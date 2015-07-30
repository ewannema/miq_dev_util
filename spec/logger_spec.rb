require 'spec_helper'

describe MiqDevUtil::Logger do
  context "with a generic logger" do
    before :each do
      @evm = double()
      @log_level = :info
      @method_name = "test_method"
      @logger = MiqDevUtil::Logger.new(@evm, @method_name)
    end

    it 'should receive emit log messages' do
      expect(@evm).to receive(:log).with(@log_level, "#{@method_name} - test_message")
      @logger.log(@log_level, "test_message")
    end

    it 'should be friendly when attributes do not exist' do
      expect(@evm).to receive(:log).with(@log_level, "#{@method_name} - No attributes for test_object")
      no_attr = Object.new
      @logger.dump_attributes(no_attr, "test_object")
    end

    it 'should output ordered attributes when they exist' do
      o = double()
      o.stub(:attributes) {{"foo" => "bar", "baz" => "bang"}}
      o_name = "my_object"
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - Begin #{o_name}.attributes")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Attribute - baz: bang")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Attribute - foo: bar")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - End #{o_name}.attributes")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - ")
      @logger.dump_attributes(o, o_name)
    end

    it 'should output ordered associations when they exist' do
      o = double()
      o.stub(:associations) {["foo", "bar", "baz"]}
      o_name = "my_object"
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - Begin #{o_name}.associations")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Association - bar")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Association - baz")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Association - foo")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - End #{o_name}.associations")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - ")
      @logger.dump_associations(o, o_name)
    end

    it 'should output ordered virtual_columns when they exist' do
      o = double()
      o.stub(:virtual_column_names) {["foo", "zippity_zam", "bar", "baz"]}
      o_name = "my_object"
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - Begin #{o_name}.virtual_columns")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Virtual Column - bar")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Virtual Column - baz")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Virtual Column - foo")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - my_object Virtual Column - zippity_zam")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - End #{o_name}.virtual_columns")
      expect(@evm).to receive(:log).once.ordered.with(@log_level, "#{@method_name} - ")
      @logger.dump_virtual_columns(o, o_name)
    end

    it 'dump_info should call other informational methods' do
      o = Object.new
      o_name = "my_object"
      expect(@logger).to receive(:dump_attributes).with(o, o_name)
      expect(@logger).to receive(:dump_associations).with(o, o_name)
      expect(@logger).to receive(:dump_virtual_columns).with(o, o_name)
      @logger.dump_info(o, o_name)
    end


    it 'dump_root should log $evm.root info' do
      @evm.stub(:root)
      expect(@logger).to receive(:dump_info).with(@evm.root, "$evm.root")
      @logger.dump_root
    end
  end
end
