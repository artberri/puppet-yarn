# See README.md for usage information
class yarn::install (
  $package_ensure,
  $package_name,
  $install_method,
  $source_install_dir,
  $symbolic_link,
) {
  assert_private()

  Exec {
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  case $install_method {
    'source': {
      ensure_packages(['wget', 'gzip', 'tar'])

      $install_dir = "${source_install_dir}/yarn"

      file { $install_dir:
        ensure => 'directory',
        owner  => 'root',
      } ->

      exec { 'wget https://yarnpkg.com/latest.tar.gz':
        command => 'wget https://yarnpkg.com/latest.tar.gz -O yarn.tar.gz',
        cwd     => $install_dir,
        user    => 'root',
        creates => "${install_dir}/yarn.tar.gz",
        require => Package['wget'],
      } ->

      exec { 'tar zvxf yarn.tar.gz':
        command => 'tar zvxf yarn.tar.gz',
        cwd     => $install_dir,
        user    => 'root',
        creates => "${install_dir}/dist",
        require => Package['gzip', 'tar'],
      } ->

      file { $symbolic_link:
        ensure => 'link',
        owner  => 'root',
        target => '/opt/yarn/dist/bin/yarn',
      }
    }

    'npm': {
      exec { "npm install -g ${package_name}":
        user     => 'root',
        command  => "npm install -g ${package_name}",
        unless   => "npm list -depth 0 -g ${package_name}",
        provider => shell,
      }
    }

    default: {
      package{ $package_name:
        ensure => $package_ensure,
      }
    }
  }

}
