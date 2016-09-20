# == Class: glare
#
# Base glare config.
#
# === Parameters
# [*package_ensure*]
#   (optional) Ensure state for package. On RedHat platforms this
#   setting is ignored and the setting from the glance class is used
#   because there is only one glance package. Defaults to 'present'.
#
# [*bind_host*]
#   (optional) The address of the host to bind to.
#   Default: 0.0.0.0
#
# [*bind_port*]
#   (optional) The port the server should bind to.
#   Default: 9494
#
# [*backlog*]
#   (optional) Backlog requests when creating socket
#   Default: 4096
#
# [*workers*]
#   (optional) Number of Glare worker processes to start
#   Default: $::os_workers
#
# [*auth_strategy*]
#   (optional) Type is authorization being used.
#   Defaults to 'keystone'
#
# [*pipeline*]
#   (optional) Partial name of a pipeline in your paste configuration file with the
#   service name removed.
#   Defaults to 'keystone'.
#
# [*manage_service*]
#   (optional) If Puppet should manage service startup / shutdown.
#   Defaults to true.
#
# [*enabled*]
#   (optional) Whether to enable services.
#   Defaults to true.
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to $::os_service_default
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to $::os_service_default
#
# [*stores*]
#   (optional) List of which store classes and store class locations are
#   currently known to glare at startup.
#   Defaults to $::os_service_default,
#   Example: file,http
#   Possible values:
#     * A comma separated list that could include:
#         * file
#         * http
#         * swift
#         * rbd
#         * sheepdog
#         * cinder
#         * vmware
#   Related Options:
#     * default_store
#
#
# [*default_store*]
#   (optional)  Allowed values: file, filesystem, http, https, swift,
#   swift+http, swift+https, swift+config, rbd, sheepdog, cinder, vsphere
#   default_store = $::os_service_default,
#
# [*filesystem_store_datadir*]
#
#   filesystem_store_datadir = /var/lib/glance/images
#
# [*os_region_name*]
#   (optional) Sets the keystone region to use.
#   Defaults to 'RegionOne'.
#
# [*allow_anonymous_access*]
#   (optional)Allow unauthenticated users to access the API with read-only
#   privileges. This only applies when using ContextMiddleware. (boolean
#   value)
#   Defaults to false
#
class glare (
  $package_ensure            = 'present',
  $bind_host                 = $::os_service_default,
  $bind_port                 = $::os_service_default,
  $backlog                   = $::os_service_default,
  $workers                   = $::os_workers,
  $auth_strategy             = 'keystone',
  $pipeline                  = 'keystone',
  $manage_service            = true,
  $enabled                   = true,
  $cert_file                 = $::os_service_default,
  $key_file                  = $::os_service_default,
  $ca_file                   = $::os_service_default,
  $stores                    = $::os_service_default,
  $default_store             = $::os_service_default,
  $filesystem_store_datadir  = '/var/lib/glare/images',
  $os_region_name            = 'RegionOne',
  $allow_anonymous_access    = $::os_service_default,
) {
  include ::glare::params
  include ::glare::db
  include ::glare::logging

  ensure_packages ( 'glare' , {
    ensure => $package_ensure,
    name   => $::glare::params::glare_package_name,
  })

  glare_config {
    'DEFAULT/bind_host'             : value => $bind_host;
    'DEFAULT/bind_port'             : value => $bind_port;
    'DEFAULT/backlog'               : value => $backlog;
    'DEFAULT/workers'               : value => $workers;
    'DEFAULT/allow_anonymous_access': value => $allow_anonymous_access;
  }

  glare_config {
    'glance_store/os_region_name'          : value   => $os_region_name;
    'glance_store/stores'                  : value   => $stores;
    'glance_store/default_store'           : value   => $default_store;
    'glance_store/filesystem_store_datadir': value   => $filesystem_store_datadir;
  }

  if $pipeline != '' {
    glare_config {
      'paste_deploy/flavor':
        ensure => present,
        value  => $pipeline,
    }
    if $pipeline == 'session' {
      glare_paste_ini { 'pipeline:glare-api-session/pipeline':
        value  => 'cors faultwrapper healthcheck versionnegotiation context glarev1api'
      }
    }
  } else {
    glare_config { 'paste_deploy/flavor': ensure => absent }
  }

  # keystone config
  if $auth_strategy == 'keystone' {
    include ::glare::keystone::authtoken
  }

  # SSL Options
  glare_config {
    'DEFAULT/cert_file': value => $cert_file;
    'DEFAULT/key_file' : value => $key_file;
    'DEFAULT/ca_file'  : value => $ca_file;
  }

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'glare':
    ensure => $service_ensure,
    name   => $::glare::params::glare_service_name,
    enable => $enabled
  }
}
