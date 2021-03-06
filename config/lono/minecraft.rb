chef_json = {
  'run_list' => ['mount', 'mc-minecraft', 'mc-mapcrafter', 'nginx'],
  'mount' => {
    'devices' => [
      {'name' => '/dev/xvdf', 'path' => '/state', 'format' => 'ext4'}
    ]
  },
  'mc-minecraft' => {
    'mount_device' => '/dev/xvdf',
    'memory' => '2048',
    'server_name' => 'minecloud',
    'jar_url' => 'https://s3.amazonaws.com/Minecraft.Download/versions/1.9/minecraft_server.1.9.jar',
    'jar_checksum' => '38a797f50c71f55202e2135a30302cf3a5c8cb494c6d225b88599542957d3a7d',
    'version' => '1.9',
    'properties' => {
      'difficulty' => '3',
      'white-list' => 'true'
    },
    'white-list' => [
      'beastageddon',
      'Orion04',
      'LastRollo',
      'ZackDankra',
      'Penagon',
      'doubtfultiger',
      'Gibson_Prime',
      'Dongleberry',
      'alexinnes',
      'Nixoninnes',
      'F_flirsten',
      'Junsui67'
    ]
  },
  'mc-mapcrafter' => {
    'map_name' => 'Minecloud',
    'world_folder' => '/state/msm/servers/minecloud/world',
    'install_dir' => '/state/mapcrafter'
  },
  'nginx' => {
    'default_root' => '/state/mapcrafter/output'
  }
}

template 'minecraft.json' do
  source 'ebs_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'Old Minecloud Server @1.9 (minecraft.aws.matt-cole.co.uk)',
    data_volume_name: 'DataVolume',
    data_volume_size: 20,
    security_groups: ['minecraft'],
    default_key_name: 'minecraft',
    hosted_zone_name: 'aws.matt-cole.co.uk.',
    dns_record: 'minecraft.aws.matt-cole.co.uk.',
    instance_start_timeout: 'PT10M',
    ami_map: AwsConstants::UBUNTU_14_04_EBS_SSD_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_VERSION'])
end
