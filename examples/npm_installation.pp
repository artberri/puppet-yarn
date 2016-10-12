#The following code require that you add the [puppet-nodejs](https://forge.puppetlabs.com/puppet/nodejs) module also, but you can adapt it
#for any other module.

class { 'nodejs':
  repo_url_suffix => '6.x',
}

class { 'yarn':
  manage_repo    => false,
  install_method => 'npm',
  require        => Class['nodejs'],
}
