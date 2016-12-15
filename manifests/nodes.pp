# See Readme
define bluegreen::nodes (
  Array $awsnodes,
) {
  bluegrean::ec2instance { $awsnodes:
    image_id           => 'ami-5ec1673e',
    pp_created_by      => $ec2_tags['created_by'],
    key_name           => 'chrismattesonaws',
    pe_master_hostname => $::ec2_local_hostname,
  }
}

Bluegreen::Nodes produces Dependency {}
