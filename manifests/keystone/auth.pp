# == Class: glare::keystone::auth
#
# Configures glare user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for glare user.
#
# [*auth_name*]
#   (Optional) Username for glare service.
#   Defaults to 'glare'.
#
# [*email*]
#   (Optional) Email for glare user.
#   Defaults to 'glare@localhost'.
#
# [*tenant*]
#   (Optional) Tenant for glare user.
#   Defaults to 'services'.
#
# [*configure_endpoint*]
#   (Optional) Should glare endpoint be configured?
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'artifact'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to the value of 'glare'.
#
# [*service_description*]
#   (Optional) Description of the service.
#   Default to 'Glare Artifact Repository Service'
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9494'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:9494'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:9494
#
class glare::keystone::auth (
  $password,
  $auth_name           = 'glare',
  $email               = 'glare@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'glare',
  $service_description = 'Glare Artifact Repository Service',
  $service_type        = 'artifact',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:9494',
  $admin_url           = 'http://127.0.0.1:9494',
  $internal_url        = 'http://127.0.0.1:9494',
) {
  include glare::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'glare-server' |>
  }
  Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Service <| name == 'glare-server' |>

  keystone::resource::service_identity { 'glare':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
