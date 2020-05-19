# == Class: glare::db::postgresql
#
# Class that configures postgresql for glare
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'glare'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'glare'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class glare::db::postgresql(
  $password,
  $dbname     = 'glare',
  $user       = 'glare',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include glare::deps

  ::openstacklib::db::postgresql { 'glare':
    password   => $password,
    dbname     => $dbname,
    user       => $user,
    encoding   => $encoding,
    privileges => $privileges,
  }

  Anchor['glare::db::begin']
  ~> Class['glare::db::postgresql']
  ~> Anchor['glare::db::end']

}
