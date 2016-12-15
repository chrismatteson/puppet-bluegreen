class bluegreen::ruby (
  $manage = true,
) {
  if $manage {
    package{'ruby':
      ensure => 'present',
    }
  }
}
