define bluegreen::load (
  $balancermembers,
  $port = 80,
) {

#  haproxy::listen {"bluegreen-${name}":
#    collect_exported => false,
#    ipaddress        => '0.0.0.0',
#    mode             => 'http',
#    options          => {
#      'option'       => ['forwardfor', 'http-server-close', 'httplog'],
#      'balance'      => 'roundrobin',
#    },
#    ports            => '80',
#  }

#  $balancermembers.each |$member| {
#    haproxy::balancermember { $member['host']:
#      listening_service => "bluegreen-${name}",
#      server_names      => $member['host'],
#      ipaddresses       => $member['ip'],
#      ports             => $member['port'],
#      options           => 'check verify none',
#    }
#  }
}

  firewall { '000 accept bluegreen web connections':
    dport  => $port,
    proto  => tcp,
    action => accept,
  }

Bluegreen::Load produces Http {
  name => $name,
  ip   => $::ipaddress,
  host => $::fqdn,
  port => $port,
}
