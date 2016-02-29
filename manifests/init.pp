application bluegreen (
  $web_count = 1,
  $db_username = 'test',
  $db_password = 'test'
) {

  $webs = $web_count.map |$i| { Http["bluegreen-web-${name}-${i}"] }

  bluegreen::db { $name:
    user     => $db_username,
    password => $db_password,
    export   => Mysqldb["bluegreen-${name}"],
  }

  $web_count.each |$i| {
    bluegreen::web { "${name}-${i}":
      consume => Mysqldb["bluegreen-${name}"],
      export  => Http["bluegreen-web-${name}-${i}"],
    }
  }

  bluegreen::load { $name:
    balancermembers => $webs,
    require         => $webs,
    export          => Http["bluegreen-web-lb-${name}"],
  }
}
