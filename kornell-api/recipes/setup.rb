include_recipe 'wildfly::setup'
include_recipe 'newrelic::setup'
include_recipe 'mysql_jdbc::setup'

template 'kornell-api-container-configuration' do
  path ::File.join(node['wildfly']['home'], 'standalone','configuration','standalone-kornell-api.xml')
  source 'standalone-kornell-api.xml.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
end