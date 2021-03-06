define bluegreen::ec2instance (
  $nodename = $name,
  $availablility_zone = $::ec2_placement_availability_zone,
  $image_id,
  $region = $::ec2_region,
  $instance_type = 'm3.medium',
  $security_groups = ['tse-agents','tse-crossconnect'],
  $subnet = 'tse-subnet-avza-1',
  $pe_version_string = $::pe_version,
  $pp_project = 'Bluegreen',
  $pp_created_by,
  $pp_department = 'TSE',
  $key_name,
  $pe_master_hostname,
) {

  $erbtemplate = $platform_name ? {
    /(windows2012|windows2008)/ => 'bluegreen/windows.erb',
    default => 'bluegreen/linux.erb',
  }

  ec2_instance { $nodename:
    ensure            => 'running',
    availability_zone => $availability_zone,
    image_id          => $image_id,
    instance_type     => $instance_type,
    key_name          => $key_name,
    region            => $region,
    security_groups   => $security_groups,
    subnet            => $subnet,
    tags              => {
      'department'    => $pp_department,
      'project'       => $pp_project,
      'created_by'    => $pp_created_by,
    },
    user_data         => template($erbtemplate),
  }

}
