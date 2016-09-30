# == Class: glare::deps
#
#  glare anchors and dependency management
#
class glare::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'glare::install::begin': }
  -> Package<| tag == 'glare'|>
  ~> anchor { 'glare::install::end': }
  -> anchor { 'glare::config::begin': }
  -> File<| tag == 'glare-config-file' |>
  ~> anchor { 'glare::config::end': }
  -> anchor { 'glare::db::begin': }
  -> anchor { 'glare::db::end': }
  ~> anchor { 'glare::dbsync::begin': }
  -> anchor { 'glare::dbsync::end': }
  ~> anchor { 'glare::service::begin': }
  ~> Service<| tag == 'glare' |>
  ~> anchor { 'glare::service::end': }

  # Ensure files are modified in the config block
  Anchor['glare::config::begin']
  -> File_line<| tag == 'glare-file-line' |>
  ~> Anchor['glare::config::end']

  # Ensure all files are in place before modifying them
  File<| tag == 'glare-config-file' |> -> File_line<| tag == 'glare-file-line' |>

  # All other inifile providers need to be processed in the config block
  Anchor['glare::config::begin'] -> Glare_config<||> ~> Anchor['glare::config::end']
  Anchor['glare::config::begin'] -> Glare_paste_ini<||> ~> Anchor['glare::config::end']

  # Support packages need to be installed in the install phase, but we don't
  # put them in the chain above because we don't want any false dependencies
  # between packages with the glare-package tag and the glare-support-package
  # tag.  Note: the package resources here will have a 'before' relationshop on
  # the glare::install::end anchor.  The line between glare-support-package and
  # glare-package should be whether or not glare services would need to be
  # restarted if the package state was changed.

  # Installation or config changes will always restart services.
  Anchor['glare::install::end'] ~> Anchor['glare::service::begin']
  Anchor['glare::config::end']  ~> Anchor['glare::service::begin']
}
