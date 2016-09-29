#
# Class to execute glare-db-manage
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the glare-db-manage command.
#   Defaults to '--config-file /etc/glare.conf'
#

class glare::db::sync(
  $extra_params  = '',
) {
  exec { 'glare-db-sync':
    command     => "glare-db-manage ${extra_params} upgrade",
    user        => 'glare',
    path        => [ '/bin/', '/usr/bin/' , '/usr/local/bin' ],
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    subscribe   => [Package['glare'], Glare_config['database/connection']],
  }
  Exec['glare-db-sync'] ~> Service<| title == 'glare' |>
}
