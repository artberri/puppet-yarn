define yarn::install (
  Boolean $production = true,
) {
  exec { "yarn-install-${title}":
    command => "yarn install --production=${production}",
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    cwd     => $title,
    unless  => 'yarn check',
  }
}
