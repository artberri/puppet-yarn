# See README.md for usage information
class yarn (
  $package_ensure      = $yarn::params::package_ensure,
  $package_name        = $yarn::params::package_name,
  $manage_repo         = $yarn::params::manage_repo,
  $install_from_source = $yarn::params::install_from_source,
  $source_install_dir  = $yarn::params::source_install_dir,
) inherits yarn::params {

  include stdlib

  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($source_install_dir)
  validate_bool($manage_repo)
  validate_bool($install_from_source)

  anchor { 'yarn::begin': } ->

  class { 'yarn::repo':
    manage_repo => $manage_repo,
  } ~>

  class { 'yarn::install':
    package_ensure      => $package_ensure,
    package_name        => $package_name,
    install_from_source => $install_from_source,
    source_install_dir  => $source_install_dir,
  } ->

  anchor { 'yarn::end': }

}
