# == Class: glare::client
#
# Installs the glare python library.
#
# === Parameters:
#
# [*ensure*]
#   (Optional) Ensure state for pachage.
#   Defaults to 'present'.
#
class glare::client (
  $ensure = 'present'
) {

  include glare::deps
  include glare::params

  package { 'python-glareclient':
    ensure => $ensure,
    name   => $::glare::params::client_package_name,
    tag    => 'openstack',
  }
}
