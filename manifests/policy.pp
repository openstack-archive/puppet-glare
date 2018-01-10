# == Class: glare::policy
#
# Configure the glare policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for glare
#   Example :
#     {
#       'glare-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'glare-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (optional) Path to the nova policy.json file
#   Defaults to /etc/glare/policy.json
#
class glare::policy (
  $policies    = {},
  $policy_path = '/etc/glare/policy.json',
) {

  include ::glare::deps
  include ::glare::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::glare::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'glare_config': policy_file => $policy_path }

}
