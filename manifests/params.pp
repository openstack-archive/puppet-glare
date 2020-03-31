# Parameters for puppet-glare
#
class glare::params {
  include openstacklib::defaults
  $pyvers = $::openstacklib::defaults::pyvers

  $group = 'glare'
  $client_package_name = "python${pyvers}-glareclient"

  case $::osfamily {
    'RedHat': {
      $glare_package_name  = 'openstack-glare'
      $glare_service_name  = 'openstack-glare-api'
      $pyceph_package_name = "python${pyvers}-rbd"
    }
    'Debian': {
      $glare_package_name  = 'glare-api'
      $glare_service_name  = 'glare-api'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
