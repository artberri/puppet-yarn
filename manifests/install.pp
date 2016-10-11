# See README.md for usage information
class yarn::install (
  $package_ensure,
  $package_name,
  $install_from_source,
  $source_install_dir,
) {
  Exec {
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }
}
