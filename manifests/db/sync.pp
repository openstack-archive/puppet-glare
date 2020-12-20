#
# Class to execute glare-db-manage
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the glare-db-manage command.
#   Defaults to ''
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class glare::db::sync(
  $extra_params    = '',
  $db_sync_timeout = 300,
) {

  include glare::deps

  exec { 'glare-db-sync':
    command     => "glare-db-manage ${extra_params} upgrade",
    user        => 'glare',
    path        => [ '/bin/', '/usr/bin/' , '/usr/local/bin' ],
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['glare::install::end'],
      Anchor['glare::config::end'],
      Anchor['glare::dbsync::begin']
    ],
    notify      => Anchor['glare::dbsync::end'],
    tag         => 'openstack-db',
  }
}
