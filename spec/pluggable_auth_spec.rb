
require 'spec_helper'
require 'fileutils'

describe 'pluggable authentication' do

  before (:all) do

    config_file = File.dirname(__FILE__) + '/resources/pluggable_auth.yml'

    @good_user = 'gavin'
    @good_pass = 'nivag'

    @bad_user = 'caleb'
    @bad_pass = 'belac'

    @auth_server = 'nats://localhost:9222'
    @server_pid = '/tmp/nats_pluggable_auth.pid'

    @s = NatsServerControl.new(@auth_server, @server_pid, "-c #{config_file}")
    @s.start_server
  end

  after (:all) do
    @s.kill_server
    FileUtils.rm_f @server_pid
  end

  it 'should fail to connect to an authenticated server without proper credentials' do
    expect do
      NATS.start(:uri => @auth_server) { NATS.stop }
    end.to raise_error NATS::Error
  end

  it 'should take user and password as separate options' do
    expect do
      NATS.start(:uri => @auth_server, :user => @good_user, :pass => @good_pass) { NATS.stop }
    end.to_not raise_error NATS::Error
  end

  it 'should fail to connect for unauthenticated use' do
    expect do
      NATS.start(:uri => @auth_server, :user => @bad_user, :pass => @bad_pass) { NATS.stop }
    end.to raise_error NATS::Error
  end

end
