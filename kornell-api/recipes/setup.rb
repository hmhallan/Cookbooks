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

ENV['JDBC_CONNECTION_STRING'] = "#{node[:kornell_api][:jdbc][:url]}"
ENV['JDBC_DRIVER'] = "#{node[:kornell_api][:jdbc][:driver]}"
ENV['JDBC_USERNAME'] = "#{node[:kornell_api][:jdbc][:username]}"
ENV['JDBC_PASSWORD'] = "#{node[:kornell_api][:jdbc][:password]}"

ENV['NEWRELIC_ENV'] = "#{node[:kornell_api][:newrelic][:environment]}"

ENV['SMTP_HOST'] = "#{node[:kornell_api][:smtp][:host]}"
ENV['SMTP_PORT'] = "#{node[:kornell_api][:smtp][:port]}"
ENV['SMTP_USERNAME'] = "#{node[:kornell_api][:smtp][:username]}"
ENV['SMTP_PASSWORD'] = "#{node[:kornell_api][:smtp][:password]}"
ENV['REPLY_TO'] = "#{node[:kornell_api][:smtp][:reply_to]}"

ENV['USER_CONTENT_BUCKET'] = "#{node[:kornell_api][:user_content]}"


bash 'start-kornell-api' do
  user 'root'
  code <<-EOC
    echo $JDBC_CONNECTION_STRING >> /tmp/sanity
  EOC
end