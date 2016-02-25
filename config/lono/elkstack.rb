require 'json'

chef_json = {
  'run_list' => ['mount', 'java', 'elkstack'],
  'elasticsearch' => {
    'network' => {
      'host' => '127.0.0.1'
    },
    'index' => {
      'number_of_replicas' => 0
    },
    'discovery' => {
      'zen' => {
        'minimum_master_nodes' => 1
      }
    },
    'path' => {
      'data' => ['/data']
    }
  },
  'kibana' => {
    'webserver_port' => 80,
    'webserver_scheme' => 'http://'
  },
  'elkstack' => {
    'config' => {
      'iptables' => {
        'enabled' => true
      },
      'kibana' => {
        'password' => ENV['KIBANA_PASSWORD'],
        'redirect' => false
      },
      'backups' => {
        'enabled' => false
      }
    }
  }
}

template 'elkstack.json' do
  source 'instance_store_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'ELK Stack',
    data_volume_name: 'DataVolume',
    data_volume_size: 50,
    security_groups: ['elkstack'],
    default_key_name: 'elkstack',
    dns_record: 'kibana.matt-cole.co.uk.',
    ami_map: AwsConstants::UBUNTU_14_04_INSTANCE_STORE_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_VERSION'])
end
