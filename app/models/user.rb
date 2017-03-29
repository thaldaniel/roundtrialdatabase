class User < ActiveRecord::Base

  def self.auth(user_name, password)
    u = User.find_by_name(user_name)
    return false unless u
    adu=WebdevToolbox::ActiveDirectoryUser.new
    adu.host = "172.18.102.9"
    adu.domain = "faserinstitut.de"
    adu.user = u.name
    adu.pass = password
    return false unless adu.login
    u
  end

end
