tstamp = ""+Time.now.strftime("%Y-%m-%d-%H-%M-%S")
directory("/var/log/stab/")
log("stab-setup-#{tstamp}")

file "/var/log/stab/stab-setup-#{tstamp}"

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

include_recipe 'wildfly::service'
