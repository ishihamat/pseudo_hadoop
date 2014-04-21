default['vagrant']['home_dir'] = "/home/vagrant"
default['common']['install_dir'] = "/usr/local"

default['jdk']['install_dir'] = default['common']['install_dir']
default['jdk']['url'] = "http://www.reucon.com/cdn/java/jdk-7u51-linux-x64.tar.gz"
default['jdk']['archive_name'] = "jdk-7u51-linux-x64.tar.gz"
default['jdk']['version'] = "jdk1.7.0_51"

default['hadoop']['install_dir'] = default['common']['install_dir']
default['hadoop']['version'] = "1.2.1"
default['hadoop']['archive_name'] = "hadoop-#{default['hadoop']['version']}.tar.gz"
default['hadoop']['url'] = "http://ftp.riken.jp/net/apache/hadoop/common/hadoop-#{default['hadoop']['version']}/#{default['hadoop']['archive_name']}"

default['hadoop']['core_site'] = [{'fs.default.name' => 'hdfs://localhost:9000', 'hadoop.tmp.dir' => '/var/local/hdfs'}]
default['hadoop']['hdfs_site'] = [{'dfs.replication' => '1'}]
default['hadoop']['mapred_site'] = [{'mapred.job.tracker ' => 'localhost:9001'}, {'mapred.system.dir' => 'mapred/system'}]

default['hive']['install_dir'] = default['common']['install_dir']
default['hive']['version'] = "0.12.0"
default['hive']['archive_name'] = "hive-#{default['hive']['version']}.tar.gz"
default['hive']['url'] = "http://ftp.riken.jp/net/apache/hive/hive-#{default['hive']['version']}/#{default['hive']['archive_name']}"
default['hive']['hive_site'] = [{'javax.jdo.option.ConnectionURL'=> 'jdbc:derby:;databaseName=/var/local/metastore/metastore_db;create=true'}]

default['hbase']['install_dir'] = default['common']['install_dir']
default['hbase']['version'] = "0.94.18"
default['hbase']['archive_name'] = "hbase-#{default['hbase']['version']}.tar.gz"
default['hbase']['url'] = "http://ftp.riken.jp/net/apache/hbase/hbase-#{default['hbase']['version']}/#{default['hbase']['archive_name']}"
default['hbase']['hbase_site'] = [{'hbase.rootdir ' => 'hdfs://localhost:9000/hbase'}, {'hbase.tmp.dir' => '/tmp/hbase'}]

default['mahout']['install_dir'] = default['common']['install_dir']
default['mahout']['version'] = "0.9"
default['mahout']['archive_name'] = "mahout-distribution-#{default['mahout']['version']}.tar.gz"
default['mahout']['url'] = "http://ftp.riken.jp/net/apache/mahout/#{default['mahout']['version']}/#{default['mahout']['archive_name']}"

