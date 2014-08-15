include_recipe 'wildfly::setup'

file "/tmp/kornell-api-setup" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
