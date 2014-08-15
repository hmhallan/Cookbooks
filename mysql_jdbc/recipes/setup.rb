log "Setup MySQL Connector J"

execute "mysql-connector-j-get-package" do
  command "aws s3 cp --region=#{node[:mysql_jdbc][:bucket_region]} #{node[:mysql_jdbc][:package_object]} #{node[:mysql_jdbc][:target]} "
end