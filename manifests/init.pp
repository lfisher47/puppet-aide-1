# the aide class manages some the configuration of aide
class aide (
    $package          = $aide::params::package,
    $version          = $aide::params::version,
    $conf_path        = $aide::params::conf_path,
    $db_path          = $aide::params::db_path,
    $db_temp_path     = $aide::params::db_temp_path,
    $hour             = $aide::params::hour,
    $minute           = $aide::params::minute,
    $email            = $aide::params::email,
    $command          = $aide::params::command,
    $check_parameters = $aide::params::check_parameters,
    $aide_rules       = {},
    $aide_watch       = {},
    $gzip_dbout       = 'yes',
    $verbose          = '5',
    $report_url       = ['file:/var/log/aide/aide.log'],
    
  ) inherits aide::params {

  validate_re($verbose, '^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$'),


  anchor { 'aide::begin': } ->
  class  { '::aide::install': } ->
  class  { '::aide::config': } ~>
  class  { '::aide::firstrun': } ->
  class  { '::aide::cron': } ->
  anchor { 'aide::end': }

  # Creates resources for aide::rule pulled from hiera
  if $aide_rules {
    create_resources('aide::rule', $aide_rules)
  }

  # Creates resources for aide::watch pulled from hiera
  if $aide_watch {
    create_resources('aide::watch', $aide_watch)
  }
}
