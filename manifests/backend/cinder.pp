#
# == Class: glare::backend::cinder
#
# Setup Glare to backend artifacts into Cinder
#
# === Parameters
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service catalog.
#   Format is : separated values of the form:
#   <service_type>:<service_name>:<endpoint_type> (string value)
#   Defaults to $::os_service_default.
#
# [*cinder_endpoint_template*]
#   (optional) Override service catalog lookup with template for cinder endpoint.
#   Should be a valid URL. Example: 'http://localhost:8776/v1/%(project_id)s'
#   Defaults to $::os_service_default.
#
# [*cinder_ca_certificates_file*]
#   (optional) Location of ca certicate file to use for cinder client requests.
#   Should be a valid ca certicate file
#   Defaults to $::os_service_default.
#
# [*cinder_http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Should be a valid integer
#   Defaults to $::os_service_default.
#
# [*cinder_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to cinder.
#   Should be a valid boolean value
#   Defaults to $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glare::backend::cinder(
  $cinder_ca_certificates_file = $::os_service_default,
  $cinder_api_insecure         = $::os_service_default,
  $cinder_catalog_info         = $::os_service_default,
  $cinder_endpoint_template    = $::os_service_default,
  $cinder_http_retries         = $::os_service_default,
  $multi_store                 = false,
) {

  include ::glare::deps

  # Glare hasn't its own store, glance_store should be used
  glare_config {
    'glance_store/cinder_api_insecure':         value => $cinder_api_insecure;
    'glance_store/cinder_catalog_info':         value => $cinder_catalog_info;
    'glance_store/cinder_http_retries':         value => $cinder_http_retries;
    'glance_store/cinder_endpoint_template':    value => $cinder_endpoint_template;
    'glance_store/cinder_ca_certificates_file': value => $cinder_ca_certificates_file;
  }

  if !$multi_store {
    glare_config { 'glance_store/default_store': value => 'cinder'; }
  }

}
