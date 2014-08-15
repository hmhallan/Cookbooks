log "Setup MySQL Connector J"

directory '/opt/newrelic'

execute "mysql-connector-j-get-package" do
  command "aws s3 cp --region=#{node[:mysql_jdbc][:bucket_region]} #{node[:mysql_jdbc][:package_object]} #{node[:mysql_jdbc][:target]} "
  not_if  { File.exist?('/opt/newrelic/newrelic.jar') }
end