define yarn::install (
  Boolean $production = true,
  Boolean $frozen_lockfile = $production,
  Optional[String] $group = undef,
  Optional[String] $user = undef,
  Optional[Array] $environment = undef,
  Optional[Integer] $timeout = undef,
) {
  include yarn

  if $frozen_lockfile {
    $yarn_opt_frozen_lockfile = '--frozen-lockfile'
  }
  else {
    $yarn_opt_frozen_lockfile = ''
  }

  exec { "yarn-install-${title}":
    command     => "yarn install --production=${production} ${yarn_opt_frozen_lockfile}",
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    cwd         => $title,
    unless      => "yarn check --production=${production}",
    user        => $user,
    group       => $group,
    environment => $environment,
    timeout     => $timeout,
  }
  Anchor['yarn::end']
  -> Exec["yarn-install-${title}"]
}
