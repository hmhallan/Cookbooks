log "Setup wildfly"

execute "wildfly-get-package" do
  command "aws s3 cp #{node[:wildfly][:package_object]} #{node[:wildfly][:package_tmp]}"
  not_if  { File.directory?('#{node[:wildfly][:home]}') }
  notifies :run, 'execute[wildfly-extract]', :immediately
end

execute "wildfly-extract" do
  command "unzip #{node[:wildfly][:package_tmp]} -d #{node[:wildfly][:extract_dir]}"
  action :nothing
  notifies :run, 'execute[wildfly-symlink]', :immediately
end

execute "wildfly-symlink" do
  command "ln -sf #{node[:wildfly][:extract_dir]}/#{node[:wildfly][:extract_name]} #{node[:wildfly][:home]}"
  action :nothing
  notifies :run, 'execute[wildfly-init]', :immediately
end

execute "wildfly-init" do
  command "ln -s #{node[:wildfly][:home]}/bin/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly"
  action :nothing
  notifies :run, 'execute[wildfly-cleanup]', :immediately
end

execute "wildfly-cleanup" do
  command "rm #{node[:wildfly][:package_tmp]}"
  action :nothing
end

template 'wildfly-defaults' do
  path '/etc/default/wildfly.conf'
  source 'wildfly.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  backup false
end

include_recipe 'wildfly::service'
