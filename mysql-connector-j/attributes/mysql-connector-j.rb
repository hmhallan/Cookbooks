default[:mysql_jdbc][:bucket_region] = 'sa-east-1'
default[:mysql_jdbc][:package_object] = 's3://dist-sa-east-1.craftware.com/MySQL/mysql-connector-java.jar'
default[:mysql_jdbc][:target] = '/opt/wildfly/standalone/deployments/mysql-connector-java.jar'
