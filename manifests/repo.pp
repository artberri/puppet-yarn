# See README.md for usage information
#
# @param manage_repo
# @param package_name
#
class yarn::repo (
  Optional[Boolean] $manage_repo = undef,
  Optional[String] $package_name = undef,
) {
  assert_private()

  if $manage_repo {
    case $facts['os']['family'] {
      'Debian': {
        include apt

        apt::source { 'yarn':
          comment  => 'Yarn source',
          location => 'https://dl.yarnpkg.com/debian/',
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
        fail("${module_name} can not manage repo on ${facts['os']['family']}/${facts['os']['name']}.")
      }
    }
  }
}
