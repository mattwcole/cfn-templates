chef_json = {
  'run_list' => ['mount', 'apt', 'mc-minecraft', 'overviewer', 'nginx'],
  'mount' => {
    'devices' => [
      {'name' => '/dev/nvme1n1', 'path' => '/state', 'format' => 'ext4'}
    ]
  },
  'mc-minecraft' => {
    'mount_device' => '/dev/nvme1n1',
    'memory' => '2048',
    'server_name' => 'minecloud',
    'jar_url' => 'https://launcher.mojang.com/v1/objects/a412fd69db1f81db3f511c1463fd304675244077/server.jar',
    'jar_checksum' => '2782d547724bc3ffc0ef6e97b2790e75c1df89241f9d4645b58c706f5e6c935b',
    'version' => '1.16.2',
    'properties' => {
      'difficulty' => '3',
      'white-list' => 'true'
    },
    'white-list' => [
      'beastageddon',
      'AFKGlen',
      'LastRollo',
      'cagnog',
      'ZackDankra',
      'Penagon',
      'doubtfultiger',
      'Gibson_Prime',
      'Dongleberry',
      'alexinnes',
      'Nixoninnes',
      'F_flirsten',
      'Junsui67',
      'Ansenia',
      'Wee_fee',
      'Souljacker',
      'MariaLilje',
      'PumbaBerry',
      'zuljalar',
      'Kaolith',
      'Sheepy1993',
      'Coati124'
    ]
  },
  'mc-mapcrafter' => {
    'map_name' => 'Minecloud',
    'world_folder' => '/state/msm/servers/minecloud/world',
    'install_dir' => '/state/mapcrafter',
    'repository' => {
      'uri' => 'http://packages.mapcrafter.org/ubuntu',
      'components' => ['main'],
      'keyserver' => 'packages.mapcrafter.org',
      'key' => 'http://packages.mapcrafter.org/ubuntu/keyring.gpg'
    }
  },
  'nginx' => {
    'default_root' => '/state/overviewer'
  },
  'java' => {
    'jdk_version' => '8'
  }
}

template 'minecraft-2020.json' do
  source 'ebs_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'Minecraft Server 2020 @1.16.2 (minecraft.matt-cole.co.uk)',
    data_volume_name: 'DataVolume',
    data_volume_size: 20,
    security_groups: ['minecraft'],
    default_key_name: 'minecraft',
    dns_record: 'minecraft.matt-cole.co.uk.',
    instance_start_timeout: 'PT10M',
    ami_map: AwsConstants::UBUNTU_16_04_EBS_SSD_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_VERSION'])
end
