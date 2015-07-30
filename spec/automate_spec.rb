require 'spec_helper'

describe MiqDevUtil::Automate do
  before :each do
    @evm = double()
    @automate_helper = MiqDevUtil::Automate.new(@evm)
  end

  context "instantiate_or_raise" do
    it 'should return the result of the instantiate on success' do
      instance_data = "some_instance"
      @evm.stub(:instantiate) {instance_data.clone()}
      instance = @automate_helper.instantiate_or_raise("somepath", "Failed.")
      expect(instance).to eq(instance_data)
    end

    it 'should raise an exception if an insantiation does not work' do
      @evm.stub(:instantiate) {nil}
      expect { @automate_helper.instantiate_or_raise("somepath", "Failed.") }.to raise_error("Failed.")
    end
  end

  context "get_instance_with_attributes" do
    it 'should raise an error when the path has a message' do
      expect { @automate_helper.get_instance_with_attributes("/do-no-go/to#here") }.to raise_error("Does not work with messages in the path.")
    end

    # This is testing the implementation which is probably not ideal, but I am \
    # not sure how to best test it.
    it 'should get the resolved instance using the full path' do
      instance = double()
      instance_path = "/some/other/path"
      full_path = "DOMAIN#{instance_path}"
      instance.stub(:name) { full_path }
      @evm.stub(:instantiate) { instance }
      expect(@evm).to receive(:instance_get).with(full_path)
      @automate_helper.get_instance_with_attributes(instance_path)
    end
  end
end
