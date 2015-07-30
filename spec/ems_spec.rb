require 'spec_helper'

describe MiqDevUtil::Code do
  context "deep_copy operations" do
    before :each do
      @o = {"a" => "foo", "nested" => {"baz" => "bar"}}
      @o_copy = MiqDevUtil::Code.deep_copy(@o)
    end

    it 'should be a different object' do
      # Object identity should be different
      expect(@o_copy.equal?(@o)).to be(false)
    end

    it 'should have a different nested object' do
      # Here is where clone would fail because the nested object is a reference
      # to the same as the parent.
      expect(@o_copy["nested"].equal?(@o["nested"])).to be(false)
    end

    it 'should still have the same values' do
      # Hash == checks keys and values
      @o_copy.should eq(@o)
    end
  end
end
