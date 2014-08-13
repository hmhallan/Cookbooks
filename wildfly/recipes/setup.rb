execute "sanity check" do
  command "touch /tmp/sanity-check-wildfly-2"
end

execute "copy wildfly tarball from S3" do
  command "aws s3 cp --region=sa-east-1 s3://dist-sa-east-1.craftware.com/WildFly/wildfly-8.1.0.Final.tar.gz /tmp/wildfly-8.1.0.Final.tar.gz"
end

execute "uncompress wildfly" do
  command "tar zxvf /tmp/wildfly-8.1.0.Final.tar.gz -C /opt"
end

execute "symlink" do
  command "tar zxvf /tmp/wildfly-8.1.0.Final.tar.gz -C /opt"
end