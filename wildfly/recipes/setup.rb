log "Setup wildfly"

execute "wildfly-get-package" do
  command "aws s3 cp --region=#{node[:wildfly][:bucket_region]} #{node[:wildfly][:package_object]} #{node[:wildfly][:package_tmp]}"
  not_if  { File.directory?('#{node[:wildfly][:home]}') }
  notifies :run, 'execute[wildfly-extract]', :immediately
end

execute "wildfly-extract" do
  command "tar zxvf #{node[:wildfly][:package_tmp]} -C #{node[:wildfly][:extract_dir]}"
  action :nothing
  notifies :run, 'execute[wildfly-symlink]', :immediately
end

execute "wildfly-symlink" do
  command "ln -s #{node[:wildfly][:extract_dir]}/#{node[:wildfly][:extract_name]} #{node[:wildfly][:home]}"
  action :nothing
  notifies :run, 'execute[wildfly-cleanup]', :immediately
end

execute "wildfly-cleanup" do
  command "rm #{node[:wildfly][:package_tmp]}"
  action :nothing
end