define yarn::install (
  Boolean $production = true,
  Optional[String] $group = undef,
  Optional[String] $user = udef,
  Optional[Integer] $timeout = undef,
) {
  exec { "yarn-install-${title}":
    command => "yarn install --production=${production}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    cwd     => $title,
    unless  => "yarn check --production=${production}",
    user    => $user,
    group   => $group,
    timeout => $timeout,
  }
}
