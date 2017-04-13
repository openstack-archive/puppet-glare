# Parameters for puppet-glare
#
class glare::params {
  include ::openstacklib::defaults

  case $::osfamily {
    'RedHat': {
      $glare_package_name    = 'openstack-glare'
      $glare_service_name    = 'openstack-glare-api'
      if ($::operatingsystem != 'fedora' and versioncmp($::operatingsystemrelease, '7') < 0) {
        $pyceph_package_name = 'python-ceph'
      } else {
        $pyceph_package_name = 'python-rbd'
      }
    }
    'Debian': {
      $glare_package_name    = 'glare-api'
      $glare_service_name    = 'glare-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
