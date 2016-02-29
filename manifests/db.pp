define bluegreen::db (
  $user,
  $password,
) {
  $db_name = "bluegreen-${name}"

  contain epel
  contain mysql::server
  class { 'mysql::client':
    bindings_enable => true,
  }
  contain mysql::client 

  Class['epel'] ->
  Class['mysql::server'] ->
  Class['mysql::client']

  wordpress::instance::db {
    create_db      => true,
    create_db_user => true,
    db_name        => $db_name,
    db_host        => '%',
    db_user        => $user,
    db_password    => $password,
  }

  file { '/tmp/create_wordpress_db.erb':
     ensure => file,
     content => template('demomodule/create_wordpress_db.erb'),
     before => Exec[ '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb; touch /tmp/mysqlloaded' ],
  }
  exec { '/usr/bin/mysql -u root  < /tmp/create_wordpress_db.erb; touch /tmp/mysqlloaded':
    creates => '/tmp/mysqlloaded',
  }

  firewall { '100 allow mysql':
    port => 3306,
    proto => tcp,
    action => 'accept',
  }
}

Bluegreen::Db produces Mysqldb {
  database => "bluegreen-${name}",
  user     => $user,
  host     => $::hostname,
  password => $password,
}
