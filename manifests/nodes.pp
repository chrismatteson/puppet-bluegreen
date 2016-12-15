# See Readme
define wordpress_app::nodes(
  Array $nodes,
) {
  bluegrean::ec2instance { $nodes:
    image_id           => 'ami-5ec1673e',
    pp_created_by      => $ec2_tags['created_by'],
    key_name           => 'chrismattesonaws',
    pe_master_hostname => $::ec2_local_hostname,
  }
}

Wordpress_app::Node produces Dependancy {
}
