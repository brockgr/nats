require 'rubygems'
require 'nats/client'

# You cannot autostart the server, so make sure you have run:
#  bundle exec nats-server -c auth_ldap.yml

def usage
  puts "Usage: pub.rb <user> <pass> <subject> <msg>"; exit
end

user, pass, subject, msg = ARGV
usage unless user and pass and subject

# Default
msg ||= 'Hello IMAP'

uri = "nats://#{user}:#{pass}@localhost:#{NATS::DEFAULT_PORT}"

NATS.on_error { |err| puts "Server Error: #{err}"; exit! }

NATS.start(:uri => uri) do
  NATS.publish(subject, msg)
  NATS.stop
end

puts "Published on [#{subject}] : '#{msg}'"
