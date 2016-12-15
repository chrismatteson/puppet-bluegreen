# See Readme
define bluegreen::web(
  String $db_host,
  String $db_name,
  String $db_user,
  String $db_password,
  String $apache_port = '8080',
  String $interface = '',
) {
  include bluegreen::web_profile

  $int =  $interface ? {
    /\S+/   => $::networking['interfaces'][$interface]['ip'],
    default => $::ipaddress }

  apache::vhost { $::fqdn:
    priority   => '10',
    vhost_name => $::fqdn,
    port       => $apache_port,
    docroot    => '/var/www/html',
    ip         => $int,
  } ->

  class {'wordpress':
    db_host        => $db_host,
    db_name        => $db_name,
    db_user        => $db_user,
    db_password    => $db_password,
    create_db      => false,
    create_db_user => false,
    install_dir    => '/var/www/html',
    require        => [
      Class['Mysql::Client'],
      Package['ruby'],
      Package['wget']
    ],
  }

  firewall { "${apache_port} allow apache access":
    dport  => [$apache_port],
    proto  => tcp,
    action => accept,
  }
}
Bluegreen::Web consumes Dependency{}
Bluegreen::Web consumes Database{
  db_host     => $host,
  db_name     => $database,
  db_user     => $user,
  db_password => $password,
}
Bluegreen::Web produces Http {
  ip   => $interface ? { /\S+/ => $::networking['interfaces'][$interface]['ip'], default => $::ipaddress },
  port => $apache_port,
  host => $::fqdn,
  status_codes => [200, 302],
}
