define bluegreen::database(
  String $database = 'wordpress',
  String $user     = 'wordpress',
  String $password = 'wordpress',
){
  include bluegreen::database_profile
  $user_host = "${user}@%"

  mysql_database { $database:
    name    => $database,
    charset => 'utf8',
    require => Class[Mysql::Server],
  } ->

  mysql_user { $user_host:
    ensure        => 'present',
    password_hash => mysql_password($password),
  } ->

  mysql_grant { "${user_host}/${database}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${database}.*",
    user       => $user_host,
  } ->
  mysql_user { "${user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($password),
  } ->
  mysql_grant { "${user}@localhost/${database}.*":
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => "${database}.*",
    user       => "${user}@localhost",
  }

}
Bluegreen::Database consumes Dependency {}
Bluegreen::Database produces Database {
  host     => $::fqdn,
  port     => '3306',
  provider => 'tcp',
}
