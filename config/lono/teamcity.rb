require 'json'

chef_json = {
  'run_list' => ['apt', 'mount', 'iptables-ng', 'teamcity'],
  'iptables-ng' =>
  {
    'rules' =>
    {
      'filter' => {
        'INPUT' => {
          '1-established' => {'rule' => '-m state --state ESTABLISHED,RELATED -j ACCEPT'},
          '2-ping' => {'rule' => '-p icmp -j ACCEPT'},
          '3-loopback' => {'rule' => '-i lo -j ACCEPT'},
          '4-ssh' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT'},
          '5-http' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT'},
          '6-teamcity' => {'rule' => '-m state --state NEW -m tcp -p tcp --dport 8111 -j ACCEPT'},
          '7-reject' => {'rule' => '-j REJECT'}},
        'FORWARD' => {
          '1-reject' => {'rule' => '-j REJECT'}}},
      'nat' => {
        'PREROUTING' => {
          '1-teamcity' => {'rule' => '-p tcp --dport 80 -j REDIRECT --to-port 8111'}}
        }
      }
    },
  'teamcity' => {
    'log_path' => '/data/teamcity/logs',
    'data_path' => '/data/teamcity/.BuildServer'
  }
}

template "teamcity.0.1.0.json" do
  source 'instance_store_instance_with_data_volume.json.erb'
  variables(
    stack_description: 'TeamCity Server',
    data_volume_name: 'Data',
    data_volume_size: 20,
    security_groups: ['teamcity'],
    dns_record: 'teamcity.matt-cole.co.uk.',
    ami_map: AwsConstants::UBUNTU_14_04_INSTANCE_STORE_MAP,
    chef_json: chef_json,
    chef_server_url: ENV['CHEF_SERVER_URL'],
    chef_validation_client_name: ENV['CHEF_VALIDATION_CLIENT_NAME'],
    chef_validation_key: ENV['CHEF_VALIDATION_KEY'],
    chef_version: ENV['CHEF_CLIENT_VERSION'])
end
