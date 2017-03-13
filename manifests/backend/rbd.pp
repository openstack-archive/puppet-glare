# == class: glare::backend::rbd
#
# configures the storage backend for glare
# as a rbd instance
#
# === parameters:
#
#  [*rbd_store_user*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_pool*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_ceph_conf*]
#    Optional. Default: $::os_service_default.
#
#  [*rbd_store_chunk_size*]
#    Optional. Default: $::os_service_default.
#
#  [*show_image_direct_url*]
#    Optional. Enables direct COW from glare to rbd
#    DEPRECATED, use show_image_direct_url in glare::api
#
#  [*package_ensure*]
#      (optional) Desired ensure state of packages.
#      accepts latest or specific versions.
#      Defaults to present.
#
#  [*rados_connect_timeout*]
#      Optinal. Timeout value (in seconds) used when connecting
#      to ceph cluster. If value <= 0, no timeout is set and
#      default librados value is used.
#      Default: $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glare::backend::rbd(
  $rbd_store_user         = $::os_service_default,
  $rbd_store_ceph_conf    = $::os_service_default,
  $rbd_store_pool         = $::os_service_default,
  $rbd_store_chunk_size   = $::os_service_default,
  $package_ensure         = 'present',
  $rados_connect_timeout  = $::os_service_default,
  $multi_store            = false,
) {

  include ::glare::deps
  include ::glare::params

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

  ensure_packages('python-ceph',
      {
        ensure => $package_ensure,
        name   => $::glare::params::pyceph_package_name,
        tag    => 'glare-support-package',
      }
  )

}
