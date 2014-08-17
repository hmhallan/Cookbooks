node[:deploy].each do |application, deploy|
  tstamp = ""+Time.now.strftime("%Y-%m-%d-%H-%M-%S")
  directory("/var/log/stab/")
  log("stab-deploy [#{application}] ")
  file "/var/log/stab/stab-deploy-#{tstamp}"

  execute "kornell_api-get-package" do
    command "aws s3 cp --region=#{node[:kornell_api][:bucket_region]} #{node[:kornell_api][:package_object]} #{node[:kornell_api][:deploy_package]}"
  end
end