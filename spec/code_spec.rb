require 'spec_helper'

describe MiqDevUtil::EMS do
  before :each do
    @hostname = "server001.example.local"
    @username = "testuser"
    @password = "testpassword"

    @ems = {}
    @ems['hostname'] = @hostname
    @ems.stub(:authentication_userid) {@username}
    @ems.stub(:authentication_password) {@password}
  end

  context "credential manipulation" do
    it 'should return a correct credential' do
      cred = MiqDevUtil::EMS.get_credentials(@ems)
      cred[:host].should == @hostname
      cred[:user].should == @username
      cred[:password].should == @password
    end

    it 'should set insecure=true by default' do
      cred = MiqDevUtil::EMS.get_credentials(@ems)
      cred[:insecure].should == true
    end

    it 'should allow insecure=false as an optional parameter' do
      cred = MiqDevUtil::EMS.get_credentials(@ems, false)
      cred[:insecure].should == false
    end
  end
end
