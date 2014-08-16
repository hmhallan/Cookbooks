include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  log("Default Deploy Steps #{application} ")

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  log("Custom Deploy Steps #{application} ")

  current_dir = ::File.join(deploy[:deploy_to], 'current')
  log("* Current dir #{current_dir} ")

end