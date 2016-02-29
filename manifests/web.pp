define bluegreen::web (
  $db_host,
  $db_name,
  $db_user,
  $db_password,
) {
  include apache
  include apache::mod::php
#  package { 'wget':
#    ensure => '1.12-5.el6_6.1',
#  } ->
  Class { 'wordpress':
    db_host              => $db_host,
    db_name              => $db_name,
    db_user              => $db_user,
    db_password          => $db_password,
    create_db            => false,
  }


  file { '/var/www/html':
    ensure => 'link',
    target => '/opt/wordpress',
    force  => true,
  }

  firewall { '101 allow http':
    port => 80,
    proto => tcp,
    action => 'accept',
  }
}

Bluegreen::Web produces Http {
  name => $name,
  ip   => $::networking['interfaces']['enp0s8']['ip'],
  port => $listen_port,
  host => $::hostname,
}

Bluegreen::Web consumes Mysqldb {
  db_name     => $database,
  db_host     => $host,
  db_user     => $user,
  db_password => $password,
}
