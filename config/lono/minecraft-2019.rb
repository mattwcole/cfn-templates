chef_json = {
  'run_list' => ['mount', 'apt', 'mc-minecraft', 'mc-mapcrafter', 'nginx'],
  'mount' => {
    'devices' => [
      {'name' => '/dev/xvdf', 'path' => '/state', 'format' => 'ext4'}
    ]
  },
  'mc-minecraft' => {
    'mount_device' => '/dev/xvdf',
    'memory' => '2048',
    'server_name' => 'minecloud',
    'jar_url' => 'https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar',
    'jar_checksum' => '942256f0bfec40f2331b1b0c55d7a683b86ee40e51fa500a2aa76cf1f1041b38',
    'version' => '1.14.2',
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
      'Junsui67',
      'Ansenia',
      'Wee_fee',
      'Souljacker',
      'MariaLilje',
      'PumbaBerry',
      'zuljalar'
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
    'default_root' => '/state/mapcrafter/output'
  },
  'java' => {
    'jdk_version' => '8'
  }
}

template 'minecraft-2019.json' do
  source 'ebs_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'Minecraft Server @1.14.2 (minecraft.matt-cole.co.uk)',
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
