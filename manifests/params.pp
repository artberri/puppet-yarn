# See README.md for usage information
class yarn::params {
  $package_ensure      = present
  $package_name        = 'yarn'
  $source_install_dir  = '/opt'
  $symbolic_link       = '/usr/local/bin/yarn'
  $user                = 'root'
  $source_url          = 'https://yarnpkg.com/latest.tar.gz'

  # set OS specific values
  case $::osfamily {
    'Windows': {
      fail("${::module_name} can not manage repo on ${::osfamily}/${::operatingsystem}.")
    }

    'Debian': {
      $manage_repo    = true
      $install_method = 'package'
    }

    'RedHat': {
      $manage_repo    = true
      $install_method = 'package'
    }

    default: {
      $manage_repo    = false
      $install_method = 'source'
    }
  }
}
