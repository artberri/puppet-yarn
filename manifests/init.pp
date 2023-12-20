# See README.md for usage information
#
# @param package_ensure
# @param package_name
# @param manage_repo
# @param install_method
# @param source_install_dir
# @param symbolic_link
# @param user
# @param source_url
#
class yarn (
  String $package_ensure     = $yarn::params::package_ensure,
  String $package_name       = $yarn::params::package_name,
  Boolean $manage_repo       = $yarn::params::manage_repo,
  String $install_method     = $yarn::params::install_method,
  String $source_install_dir = $yarn::params::source_install_dir,
  String $symbolic_link      = $yarn::params::symbolic_link,
  String $user               = $yarn::params::user,
  String $source_url         = $yarn::params::source_url,
) inherits yarn::params {
  include stdlib

  class { 'yarn::repo':
    manage_repo  => $manage_repo,
    package_name => $package_name,
  }
  -> class { 'yarn::install':
    package_ensure     => $package_ensure,
    package_name       => $package_name,
    install_method     => $install_method,
    source_install_dir => $source_install_dir,
    symbolic_link      => $symbolic_link,
    user               => $user,
    source_url         => $source_url,
  }
}
