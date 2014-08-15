log "Running wildfly setup"

execute "get-package-object" do
  command "aws s3 cp --region=#{node[:wildfly][:bucket_region]} #{node[:wildfly][:package_object]} #{node[:wildfly][:package_tmp]}"
  not_if  { File.directory?('#{node[:wildfly][:home]}') }
  notifies :run, 'execute[extract-wildfly]', :immediately
end

execute "extract-wildfly" do
  command "tar zxvf #{node[:wildfly][:package_tmp]} -C #{node[:wildfly][:extract_dir]}"
  action :nothing
  notifies :run, 'execute[create-symlink]', :immediately
end

execute "create-symlink" do
  command "ln -s #{node[:wildfly][:extract_dir]}/#{node[:wildfly][:extract_name]} #{node[:wildfly][:home]}"
  action :nothing
  notifies :run, 'execute[cleanup]', :immediately
end

execute "cleanup" do
  command "rm #{node[:wildfly][:package_tmp]}"
  action :nothing
end