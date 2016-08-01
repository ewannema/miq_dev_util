# The External Management System (EMS) class holds methods that apply to EMS
# objects in ManageIQ.

class MiqDevUtil::EMS
  # Return a hash containing the attributes that are commonly used to connect
  # directly to the EMS.
  # * :host
  # * :user
  # * :password
  # * :insecure
  def self.get_credentials(ems, insecure=true)
    {
      host: ems.hostname,
      user: ems.authentication_userid,
      password: ems.authentication_password,
      insecure: insecure
    }
  end
end

