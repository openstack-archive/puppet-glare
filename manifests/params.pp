# Parameters for puppet-glare
#
class glare::params {
  include ::openstacklib::defaults

  case $::osfamily {
    'RedHat': {
    }
    'Debian': {
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
