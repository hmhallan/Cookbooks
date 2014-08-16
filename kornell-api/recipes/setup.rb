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

log("Setting Envirnment")

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
ENV['JAVA_OPTS'] = " -javaagent:/opt/newrelic/newrelic.jar"

log("Starting Kornell API")

bash 'start-kornell-api' do
  user 'root'
  code <<-EOC
    /opt/wildfly/bin/standalone.sh -c standalone-kornell-api.xml \
 -b 0.0.0.0 \
 -Dnewrelic.environment=${NEWRELIC_ENV-"unknown"} \
 -DJNDI_ROOT="java:/" \
 -DJNDI_DATASOURCE="datasources/KornellDS" \
 -Dkornell.api.jdbc.url=$JDBC_CONNECTION_STRING \
 -Dkornell.api.jdbc.driver=$JDBC_DRIVER \
 -Dkornell.api.jdbc.username=$JDBC_USERNAME \
 -Dkornell.api.jdbc.password=$JDBC_PASSWORD &
  EOC
end