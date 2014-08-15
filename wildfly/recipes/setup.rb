log "ALL YOU NEED IS LOG"

execute "copy wildfly tarball from S3" do
  command "aws s3 cp --region=#{node[:wildfly][:bucket_region]} #{node[:wildfly][:package_object]} #{node[:wildfly][:package_tmp]}"
end

execute "uncompress wildfly" do
  command "tar zxvf #{node[:wildfly][:package_tmp]} -C #{node[:wildfly][:extract_dir]}"
end

execute "create symlink" do
  command "ln -s #{node[:wildfly][:extract_dir]}/#{node[:wildfly][:extract_name]} #{node[:wildfly][:home]}"
end

file "#{node[:wildfly][:package_tmp]}" do
  action :delete
end
