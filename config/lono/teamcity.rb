require 'json'

chef_json = {
  'run_list' => ['mount', 'iptables-ng', 'teamcity', 'rbenv-install-rubies'],
  'mount' => {
    'devices' => [
      {'name' => '/dev/xvdf', 'path' => '/data', 'format' => 'ext4'}
    ]
  },
  'iptables-ng' => {
    'rules' => {
      'filter' => {
        'INPUT' => {
          '1-established' => {'rule' => '-m state --state ESTABLISHED,RELATED -j ACCEPT'},
          '2-ping' => {'rule' => '-p icmp -j ACCEPT'},
          '3-loopback' => {'rule' => '-i lo -j ACCEPT'},
          '4-ssh' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT'},
          '5-http' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT'},
          '6-teamcity' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 8111 -j ACCEPT'},
          '7-reject' => {'rule' => '-j REJECT'}
        },
        'FORWARD' => {
          '1-reject' => {'rule' => '-j REJECT'}
        }
      },
      'nat' => {
        'PREROUTING' => {
          '1-teamcity' => {'rule' => '-p tcp --dport 80 -j REDIRECT --to-port 8111'}
        }
      }
    }
  },
  'teamcity' => {
    'log_path' => '/data/teamcity/logs',
    'data_path' => '/data/teamcity/.BuildServer',
    'server_mem_opts' => '-Xms750m -Xmx750m -XX:MaxPermSize=270m'
  },
  'rbenv' => {
    'group_users' => ['teamcity']
  },
  'rbenv_install_rubies' => {
    'global_version' => '1.9.3-p551',
    'gems' => ['bundler', 'rake']
  }
}

template 'teamcity.json' do
  source 'instance_store_instance_with_data_volume.json.erb'
  variables(
    init_script: 'ubuntu_init.sh',
    stack_description: 'TeamCity Server',
    data_volume_name: 'DataVolume',
    data_volume_size: 20,
    security_groups: ['teamcity'],
    default_key_name: 'teamcity',
    dns_record: 'teamcity.matt-cole.co.uk.',
    instance_start_timeout: 'PT20M',
    ami_map: AwsConstants::UBUNTU_14_04_INSTANCE_STORE_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_VERSION'])
end
