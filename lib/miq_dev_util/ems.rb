class MiqDevUtil::EMS
  def self.get_credentials(ems, insecure=true)
    {
      host: ems['hostname'],
      user: ems.authentication_userid,
      password: ems.authentication_password,
      insecure: insecure
    }
  end
end

