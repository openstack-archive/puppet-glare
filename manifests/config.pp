# == Class: glare::config
#
# This class is used to manage arbitrary glare configurations.
#
# === Parameters
#
# [*glare_config*]
#   (optional) Allow configuration of arbitrary glare configurations.
#   The value is an hash of glare_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   glare_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class glare::config (
  $glare_config = {},
) {

  validate_hash($glare_config)

  create_resources('glare_config', $glare_config)
}
