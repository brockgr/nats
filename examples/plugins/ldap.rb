require 'net/ldap' # "gem 'net-ldap'" in Gemfile

class NatsAuthLdap

  # Not that if "ldap.bind" is slow, it will block your nats server - this maybe better wrapped in a fiber
  def authenticate( server, user, pass )
    ldap = Net::LDAP.new :host => "10.0.0.2", :port => 389, :auth => {:method => :simple, :username => user, :password => pass}
    if ldap.bind
      yield(true)
    else
      yield(false)
    end
  end

end
