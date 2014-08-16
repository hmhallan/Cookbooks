
node[:deploy].each do |application, deploy|
  log("Default Deploy Steps #{application} ")
  log("* deploy_to = #{node[:deploy][:kornell_api][:deploy_to]}")
end