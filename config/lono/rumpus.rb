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
    'jar_url' => 'https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar',
    'jar_checksum' => '444d30d903a1ef489b6737bb9d021494faf23434ca8568fd72ce2e3d40b32506',
    'version' => '1.16.4',
    'properties' => {
      'difficulty' => '3',
      'white-list' => 'true'
    },
    'white-list' => [
      'beastageddon',
      'MariaLilje'
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

template 'rumpus-2020.json' do
  source 'ebs_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'Minecraft Server @1.16.4 (rumpus.matt-cole.co.uk)',
    data_volume_name: 'DataVolume',
    data_volume_size: 20,
    security_groups: ['minecraft'],
    default_key_name: 'minecraft',
    dns_record: 'rumpus.matt-cole.co.uk.',
    instance_start_timeout: 'PT10M',
    ami_map: AwsConstants::UBUNTU_16_04_EBS_SSD_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_VERSION'])
end
