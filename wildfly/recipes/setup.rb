execute "sanity check" do
  command "touch /tmp/sanity-check-wildfly-param"
end

execute "copy wildfly tarball from S3" do
  command "aws s3 cp --region=sa-east-1 #{node[:wildfly][:package_object]} /tmp/wildfly-8.1.0.Final.tar.gz"
end

execute "uncompress wildfly" do
  command "tar zxvf /tmp/wildfly-8.1.0.Final.tar.gz -C /opt"
end

execute "create symlink" do
  command "ln -s /opt/wildfly-8.1.0.Final /opt/wildfly"
end