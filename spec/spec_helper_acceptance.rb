require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = []

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => module_root, :module_name => 'yarn',
          :target_module_path => '/etc/puppet/modules')
      on host, puppet('module','install','puppetlabs-stdlib','--version','4.9.0')
      on host, puppet('module','install','puppetlabs-apt','--version','2.3.0')
      on host, puppet('module','install','puppet-nodejs','--version','1.3.0')
    end
  end
end
