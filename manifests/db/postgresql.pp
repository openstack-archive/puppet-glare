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
# == Dependencies
#
# == Examples
#
# == Authors
#
# == Copyright
#
class glare::db::postgresql(
  $password,
  $dbname     = 'glare',
  $user       = 'glare',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  Class['glare::db::postgresql'] -> Service<| title == 'glare' |>

  ::openstacklib::db::postgresql { 'glare':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  ::Openstacklib::Db::Postgresql['glare'] ~> Exec<| title == 'glare-db-sync' |>

}
