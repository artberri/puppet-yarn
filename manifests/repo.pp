# See README.md for usage information
class yarn::repo (
  $manage_repo,
  $package_name,
) {
  assert_private()

  if $manage_repo {

    case $::osfamily {
      'Debian': {
        include apt

        apt::source { 'yarn':
          comment  => 'Yarn source',
          location => 'http://dl.yarnpkg.com/debian/',
          release  => 'stable',
          repos    => 'main',
          key      => {
            'id'     => '72ECF46A56B4AD39C907BBB71646B01B86E50310',
            'source' => 'https://dl.yarnpkg.com/debian/pubkey.gpg',
          },
        }

        Apt::Source['yarn'] -> Class['apt::update'] -> Package[$package_name]
      }

      'RedHat': {
        yumrepo { 'yarn':
          descr    => 'Yarn Repository',
          baseurl  => 'https://dl.yarnpkg.com/rpm/',
          gpgkey   => 'https://dl.yarnpkg.com/rpm/pubkey.gpg',
          gpgcheck => 1,
          enabled  => 1,
        }

        Yumrepo['yarn'] -> Package[$package_name]
      }

      default: {
        fail("${::module_name} can not manage repo on ${::osfamily}/${::operatingsystem}.")
      }
    }

  }

}
