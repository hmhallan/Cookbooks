include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  tstamp = ""+Time.now.strftime("%Y-%m-%d-%H-%M-%S")
  log("stab-deploy [#{application}] ")
  directory("/var/log/stab/")
  file "/var/log/stab/stab-deploy-#{tstamp}"

  execute "kornell_api-get-package" do
    command "aws s3 cp #{node[:build][:path]} #{node[:build][:deploy_path]}"
  end

  file "#{node[:build][:deploy_path]}.dodeploy" do
    action :create
  end
end

service "wildfly" do
  action :restart
end
