chef_json = {
  'run_list' => ['mount', 'valheim'],
  'mount' => {
    'devices' => [
      {'name' => '/dev/nvme1n1', 'path' => '/state', 'format' => 'ext4'}
    ]
  },
  'valheim' => {
    'config' => {
      'savedir' => '/state/valheim',
      'serverpassword' => ENV['VALHEIM_SERVER_PASSWORD']
    }
  }
}

template 'valheim.json' do
  source 'ebs_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'Valheim Server (valheim.aws.matt-cole.co.uk)',
    data_volume_name: 'DataVolume',
    data_volume_size: 20,
    security_groups: ['valheim'],
    default_key_name: 'valheim',
    hosted_zone_name: 'aws.matt-cole.co.uk.',
    dns_record: 'valheim.aws.matt-cole.co.uk.',
    instance_start_timeout: 'PT10M',
    ami_map: AwsConstants::UBUNTU_16_04_EBS_SSD_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: '14')
end
