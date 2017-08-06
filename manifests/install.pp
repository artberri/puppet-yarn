define yarn::install (
  Boolean $production = true,
  Optional[String] $group = undef,
  Optional[String] $user = undef,
  Optional[Integer] $timeout = undef,
) {
  include yarn

  exec { "yarn-install-${title}":
    command => "yarn install --production=${production}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    cwd     => $title,
    unless  => "yarn check --production=${production}",
    user    => $user,
    group   => $group,
    timeout => $timeout,
  }
  Anchor['yarn::end']
  -> Exec["yarn-install-${title}"]
}
