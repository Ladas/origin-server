require File.expand_path('../coverage_helper.rb', __FILE__)

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

if(File.exist?('/etc/fedora-release'))
  PHP_VERSION = 'php-5.4'
else
  PHP_VERSION = 'php-5.3'
end

def gen_uuid
  %x[/usr/bin/uuidgen].gsub('-', '').strip 
end

def register_user(login, password)
  if ENV['REGISTER_USER']
    accnt = UserAccount.new(user: login, password: password)
    accnt.save
  end
end

def stubber
  @container = OpenShift::ApplicationContainerProxy.find_one
  @container.stubs(:reserve_uid).returns(555)
  @container.stubs(:unreserve_uid)
  @container.stubs(:restart).returns(ResultIO.new)
  @container.stubs(:reload).returns(ResultIO.new)
  @container.stubs(:stop).returns(ResultIO.new)
  @container.stubs(:force_stop).returns(ResultIO.new)
  @container.stubs(:start).returns(ResultIO.new)
  @container.stubs(:add_alias).returns(ResultIO.new)
  @container.stubs(:remove_alias).returns(ResultIO.new)
  @container.stubs(:add_ssl_cert).returns(ResultIO.new)
  @container.stubs(:remove_ssl_cert).returns(ResultIO.new)
  @container.stubs(:tidy).returns(ResultIO.new)
  @container.stubs(:threaddump).returns(ResultIO.new)
  @container.stubs(:create).returns(ResultIO.new)
  @container.stubs(:destroy).returns(ResultIO.new)
  @container.stubs(:update_namespace).returns(ResultIO.new)
  @container.stubs(:configure_cartridge).returns(ResultIO.new)
  @container.stubs(:deconfigure_cartridge).returns(ResultIO.new)
  @container.stubs(:get_public_hostname).returns("node_dns")
  @container.stubs(:set_quota).returns(ResultIO.new)
  OpenShift::ApplicationContainerProxy.stubs(:execute_parallel_jobs)
  OpenShift::ApplicationContainerProxy.stubs(:find_available).returns(@container)
  OpenShift::ApplicationContainerProxy.stubs(:find_one).returns(@container)
  dns = mock()
  OpenShift::DnsService.stubs(:instance).returns(dns)
  dns.stubs(:register_application)
  dns.stubs(:deregister_application)
  dns.stubs(:publish)
  dns.stubs(:close)
  Gear.any_instance.stubs(:get_proxy).returns(@container)
  Gear.stubs(:base_filesystem_gb).returns(1)
  Gear.stubs(:get_gear_states).returns("")
end
