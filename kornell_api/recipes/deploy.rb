node[:deploy].each do |application, deploy|
  log("** Deploying #{application} ")

  execute "wildfly-get-package" do
    command "aws s3 cp --region=#{node[:kornell_api][:bucket_region]} #{node[:kornell_api][:package_object]} #{node[:kornell_api][:deploy_package]}"
  end
end