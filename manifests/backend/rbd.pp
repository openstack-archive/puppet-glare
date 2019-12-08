# == Class: glare::backend::rbd
#
# Configures the storage backend for glare
# as a rbd instance.
#
# === Parameters:
#
# [*rbd_store_user*]
#   (Optional) Default: $::os_service_default.
#
# [*rbd_store_pool*]
#   (Optional) Default: $::os_service_default.
#
# [*rbd_store_ceph_conf*]
#   (Optional) Default: $::os_service_default.
#
# [*rbd_store_chunk_size*]
#   (Optional) Default: $::os_service_default.
#
# [*package_manage*]
#   (Optional) Whether manage ceph package state or not.
#   Defaults to true
#
# [*package_ensure*]
#   (Optional) Desired ensure state of packages.
#   Defaults to present
#
# [*rados_connect_timeout*]
#   (Optional) Timeout value (in seconds) used when connecting
#   to ceph cluster. If value <= 0, no timeout is set and
#   default librados value is used.
#   Default: $::os_service_default
#
# [*multi_store*]
#   (Optional) Boolean describing if multiple backends will be configured.
#   Defaults to false
#
class glare::backend::rbd(
  $rbd_store_user        = $::os_service_default,
  $rbd_store_ceph_conf   = $::os_service_default,
  $rbd_store_pool        = $::os_service_default,
  $rbd_store_chunk_size  = $::os_service_default,
  $package_manage        = true,
  $package_ensure        = 'present',
  $rados_connect_timeout = $::os_service_default,
  $multi_store           = false,
) {

  include glare::deps
  include glare::params

  # Glare hasn't its own store, glance_store should be used
  glare_config {
    'glance_store/rbd_store_ceph_conf':   value => $rbd_store_ceph_conf;
    'glance_store/rbd_store_user':        value => $rbd_store_user;
    'glance_store/rbd_store_pool':        value => $rbd_store_pool;
    'glance_store/rbd_store_chunk_size':  value => $rbd_store_chunk_size;
    'glance_store/rados_connect_timeout': value => $rados_connect_timeout;
  }

  if !$multi_store {
    glare_config { 'glance_store/default_store': value => 'rbd'; }
  }

  if $package_manage {
    ensure_packages('python-ceph', {
      ensure => $package_ensure,
      name   => $::glare::params::pyceph_package_name,
      tag    => 'glare-support-package',
    })
  }

}
