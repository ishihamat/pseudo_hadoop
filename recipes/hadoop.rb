#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: hadoop
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/vagrant/hadoop-#{node['hadoop']['version']}.tar.gz")
    execute "copy #{node['hadoop']['archive_name']}" do
        command "cp /vagrant/#{node['hadoop']['archive_name']} /tmp"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hadoop]", :immediately
        not_if { File.exists?("#{node['hadoop']['install_dir']}/hadoop-#{node['hadoop']['version']}") }
    end
else
    execute "download hadoop" do
        cwd "/tmp"
        command "curl -L -O #{node['hadoop']['url']}"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hadoop]", :immediately
        not_if { File.exists?("#{node['hadoop']['install_dir']}/hadoop-#{node['hadoop']['version']}") }
    end
end

execute "untar hadoop" do
    cwd "/tmp"
    command "tar zxf #{node['hadoop']['archive_name']}"
    user "vagrant"
    group "vagrant"
    action :run
    notifies :run, "execute[install hadoop]", :immediately
    not_if { File.exists?("#{node['hadoop']['install_dir']}/hadoop-#{node['hadoop']['version']}") }
end

execute "install hadoop" do
    cwd "/tmp"
    command <<-_EOF_
        mv hadoop-#{node['hadoop']['version']} #{node['hadoop']['install_dir']}
        ln -s #{node['hadoop']['install_dir']}/hadoop-#{node['hadoop']['version']} #{node['hadoop']['install_dir']}/hadoop
    _EOF_
    user "root"
    group "root"
    action :run
    not_if { File.exists?("#{node['hadoop']['install_dir']}/hadoop-#{node['hadoop']['version']}") }
end

directory "/var/local/hdfs" do
    owner 'vagrant'
    group 'vagrant'
    recursive true
    mode "0755"
    action :create
    not_if { File.exists?("/var/local/hdfs") }
end

template "#{node['hadoop']['install_dir']}/hadoop/conf/core-site.xml" do
    source "core-site.xml.erb"
    group "vagrant"
    owner "vagrant"
    mode "0644"
end

template "#{node['hadoop']['install_dir']}/hadoop/conf/hdfs-site.xml" do
    source "hdfs-site.xml.erb"
    group "vagrant"
    owner "vagrant"
    mode "0644"
end

template "#{node['hadoop']['install_dir']}/hadoop/conf/mapred-site.xml" do
    source "mapred-site.xml.erb"
    group "vagrant"
    owner "vagrant"
    mode "0644"
end

# -----------------------------------------
# stop hadoop

execute "stop hadoop" do
    command "#{node['hadoop']['install_dir']}/hadoop/bin/stop-all.sh"
    user "vagrant"
    group "vagrant"
    action :run
    environment "JAVA_HOME" => "#{node['jdk']['install_dir']}/jdk"
end

# -----------------------------------------
# namenode format
# TODO:一度きりの実行にしたい
execute "namenode format" do
    command "#{node['hadoop']['install_dir']}/hadoop/bin/hadoop namenode -format -force"
    user "vagrant"
    group "vagrant"
    action :run
    environment "JAVA_HOME" => "#{node['jdk']['install_dir']}/jdk"
end

# -----------------------------------------
# start hadoop

execute "start hadoop" do
    command "#{node['hadoop']['install_dir']}/hadoop/bin/start-all.sh"
    user "vagrant"
    group "vagrant"
    action :run
    environment "JAVA_HOME" => "#{node['jdk']['install_dir']}/jdk"
end

