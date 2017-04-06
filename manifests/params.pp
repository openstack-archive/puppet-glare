# Parameters for puppet-glare
#
class glare::params {
  include ::openstacklib::defaults

  case $::osfamily {
    'RedHat': {
      $glare_package_name    = 'openstack-glare'
      $glare_service_name    = 'openstack-glare-api'
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
