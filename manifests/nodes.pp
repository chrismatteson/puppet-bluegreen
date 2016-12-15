# See Readme
define bluegreen::nodes (
  Array $awsnodes,
) {
  $public_key = split($ec2_metadata['public-keys']['0']['openssh-key'], ' ')
  $awskey = $public_key[2]

  bluegreen::ec2instance { $awsnodes:
    image_id           => 'ami-5ec1673e',
    pp_created_by      => 'chris.matteson', #$ec2_tags['created_by'],
    key_name           => $awskey,
    pe_master_hostname => $::ec2_local_hostname,
  }
}

Bluegreen::Nodes produces Dependency {}
