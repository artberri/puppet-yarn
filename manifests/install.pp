# See README.md for usage information
class yarn::install (
  $package_ensure,
  $package_name,
  $install_method,
  $source_install_dir,
  $symbolic_link,
  $user,
  $source_url,
) {
  assert_private()

  Exec {
    path   => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  $install_dir = "${source_install_dir}/yarn"

  case $install_method {
    'source': {
      if ($package_ensure == 'absent') {
        file { $symbolic_link:
          ensure => 'absent',
        } ->

        file { $install_dir:
          ensure => 'absent',
          force  => true,
        }
      }
      else {
        ensure_packages(['wget', 'gzip', 'tar'])

        file { $install_dir:
          ensure => 'directory',
          owner  => $user,
        } ->

        exec { "wget ${source_url}":
          command => "wget ${source_url} -O yarn.tar.gz",
          cwd     => $install_dir,
          user    => $user,
          creates => "${install_dir}/yarn.tar.gz",
          require => Package['wget'],
        } ->

        exec { 'tar zvxf yarn.tar.gz':
          command => 'tar zvxf yarn.tar.gz',
          cwd     => $install_dir,
          user    => $user,
          creates => "${install_dir}/dist",
          require => Package['gzip', 'tar'],
        } ->

        file { $symbolic_link:
          ensure => 'link',
          owner  => $user,
          target => '/opt/yarn/dist/bin/yarn',
        }
      }
    }

    'npm': {
      if ($package_ensure == 'absent') {
        exec { "npm uninstall -g ${package_name}":
          user     => $user,
          command  => "npm uninstall -g ${package_name}",
          onlyif   => "npm list -depth 0 -g ${package_name}",
          provider => shell,
        }
      }
      else {
        exec { "npm install -g ${package_name}":
          user     => $user,
          command  => "npm install -g ${package_name}",
          unless   => "npm list -depth 0 -g ${package_name}",
          provider => shell,
        }
      }
    }

    default: {
      package{ $package_name:
        ensure => $package_ensure,
      }
    }
  }

}
