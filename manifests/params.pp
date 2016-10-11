# See README.md for usage information
class yarn::params {
  $package_ensure      = present
  $package_name        = 'yarn'
  $source_install_dir  = '/opt'

  # set OS specific values
  case $::osfamily {
    'Windows': {
      $manage_repo         = false
      $install_from_source = false
    }

    'Debian': {
      $manage_repo         = true
      $install_from_source = false
    }

    'RedHat': {
      $manage_repo         = true
      $install_from_source = false
    }

    default: {
      $manage_repo         = false
      $install_from_source = true
    }
  }
}
