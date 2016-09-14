#
# Class to execute glare-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the glare-dbsync command.
#   Defaults to undef
#
class glare::db::sync(
  $extra_params  = undef,
) {
  exec { 'glare-db-sync':
    command     => "glare-manage db_sync ${extra_params}",
    path        => '/usr/bin',
    user        => 'glare',
    refreshonly => true,
    subscribe   => [Package['glare'], Glare_config['database/connection']],
  }

  Exec['glare-manage db_sync'] ~> Service<| title == 'glare' |>
}
