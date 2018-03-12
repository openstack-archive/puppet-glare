#
# Class to execute glare-db-manage
#
# == Parameters
#
# [*extra_params*]
#   (optional) String of extra command line parameters to append
#   to the glare-db-manage command.
#   Defaults to ''
#
class glare::db::sync(
  $extra_params  = '',
) {

  include ::glare::deps

  exec { 'glare-db-sync':
    command     => "glare-db-manage ${extra_params} upgrade",
    user        => 'glare',
    path        => [ '/bin/', '/usr/bin/' , '/usr/local/bin' ],
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
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
