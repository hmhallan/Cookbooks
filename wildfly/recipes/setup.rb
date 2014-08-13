#Sanity Check
file "/tmp/hello-setup-wildfly-1" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "copy wildfly tarball from S3" do
  command "aws s3 cp --region=sa-east-1 s3://dist-sa-east-1.craftware.com/WildFly/wildfly-8.1.0.Final.tar.gz /tmp/wildfly-8.1.0.Final.tar.gz"
end
