#The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
#for any other module.

class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn': }

Package['nodejs'] -> Package['yarn']

if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] =~ /^5\.(\d+)/ {
  class { 'epel': }
  Class['epel'] -> Class['nodejs'] -> Class['yarn']
}
