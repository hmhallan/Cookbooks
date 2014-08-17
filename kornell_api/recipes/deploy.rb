include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end


#  tstamp = ""+Time.now.strftime("%Y-%m-%d-%H-%M-%S")
#  directory("/var/log/stab/")
#  log("stab-deploy [#{application}] ")
#  file "/var/log/stab/stab-deploy-#{tstamp}"

  execute "kornell_api-get-package" do
    command "aws s3 cp --region=#{node[:kornell_api][:bucket_region]} #{node[:kornell_api][:package_object]} #{node[:kornell_api][:deploy_package]}"
  end
end