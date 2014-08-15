include_recipe 'wildfly::setup'
include_recipe 'newrelic::setup'

file "/tmp/kornell-api-setup" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end
