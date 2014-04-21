#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: hive
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/vagrant/#{node['hive']['archive_name']}")
    execute "copy #{node['hive']['archive_name']}" do
        command "cp /vagrant/#{node['hive']['archive_name']} /tmp"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hive]", :immediately
        not_if { File.exists?("#{node['hive']['install_dir']}/hive-#{node['hive']['version']}") }
    end
else
    execute "download hive" do
        cwd "/tmp"
        command "curl -L -O #{node['hive']['url']}"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hive]", :immediately
        not_if { File.exists?("#{node['hive']['install_dir']}/hive-#{node['hive']['version']}") }
    end
end


execute "untar hive" do
    cwd "/tmp"
    command "tar zxf #{node['hive']['archive_name']}"
    user "vagrant"
    group "vagrant"
    action :run
    notifies :run, "execute[install hive]", :immediately
    not_if { File.exists?("#{node['hive']['install_dir']}/hive-#{node['hive']['version']}") }
end


execute "install hive" do
    cwd "/tmp"
    command <<-_EOF_
        mv hive-#{node['hive']['version']} #{node['hive']['install_dir']}
        ln -s #{node['hive']['install_dir']}/hive-#{node['hive']['version']} #{node['hive']['install_dir']}/hive
    _EOF_
    user "root"
    group "root"
    action :run
    not_if { File.exists?("#{node['hive']['install_dir']}/hive-#{node['hive']['version']}") }
end

template "#{node['hive']['install_dir']}/hive/conf/hive-site.xml" do
    source "hive-site.xml.erb"
    group "vagrant"
    owner "vagrant"
    mode "0644"
end

directory "/var/local/metastore" do
    owner 'vagrant'
    group 'vagrant'
    recursive true
    mode "0755"
    action :create
    not_if { File.exists?("/var/local/metastore") }
end

