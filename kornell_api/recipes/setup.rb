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

ENV['JDBC_USERNAME'] = "#{node[:kornell_api][:jdbc][:username]}"
ENV['JDBC_PASSWORD'] = "#{node[:kornell_api][:jdbc][:password]}"

ENV['SMTP_HOST'] = "#{node[:kornell_api][:smtp][:host]}"
ENV['SMTP_PORT'] = "#{node[:kornell_api][:smtp][:port]}"
ENV['SMTP_USERNAME'] = "#{node[:kornell_api][:smtp][:username]}"
ENV['SMTP_PASSWORD'] = "#{node[:kornell_api][:smtp][:password]}"
ENV['REPLY_TO'] = "#{node[:kornell_api][:smtp][:reply_to]}"

ENV['USER_CONTENT_BUCKET'] = "#{node[:kornell_api][:user_content]}"
ENV['JAVA_OPTS'] = " -javaagent:/opt/newrelic/newrelic.jar"

log("Starting Kornell API")

wildfly_cmd = "/opt/wildfly/bin/standalone.sh"
wildfly_cmd <<= " -c standalone-kornell-api.xml"
wildfly_cmd <<= " -b 0.0.0.0"
wildfly_cmd <<= " -Dnewrelic.environment=#{node[:kornell_api][:newrelic][:environment]}"
wildfly_cmd <<= ' -DJNDI_ROOT="java:/"'
wildfly_cmd <<= ' -DJNDI_DATASOURCE="datasources/KornellDS"'
wildfly_cmd <<= " -Dkornell.api.jdbc.url=#{node[:kornell_api][:jdbc][:url]}"
wildfly_cmd <<= " -Dkornell.api.jdbc.driver=#{node[:kornell_api][:jdbc][:driver]}"
wildfly_cmd <<= " -Dkornell.api.jdbc.password=$JDBC_PASSWORD"
wildfly_cmd <<= " -Dkornell.api.jdbc.username=$JDBC_USERNAME"
wildfly_cmd <<= " &"

log("[#{wildfly_cmd}]")


bash 'start-kornell-api' do
  user 'root'
  code <<-EOH
    echo 'Starting Wildfly [#{wildfly_cmd}]' > /var/log/wildfly_cmd
    #{wildfly_cmd}
    EOH
end