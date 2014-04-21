#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: JDK
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/vagrant/#{node['jdk']['archive_name']}")
    execute "copy #{node['jdk']['archive_name']}" do
        command "cp /vagrant/#{node['jdk']['archive_name']} /tmp"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar JDK]", :immediately
        not_if { File.exists?("#{node['jdk']['install_dir']}/#{node['jdk']['version']}") }
    end
else
    execute "download JDK" do
        cwd "/tmp"
        command "curl -L -O #{node['jdk']['url']}"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar JDK]", :immediately
        not_if { File.exists?("#{node['jdk']['install_dir']}/#{node['jdk']['version']}") }
    end
end


execute "untar JDK" do
    cwd "/tmp"
    command "tar zxf #{node['jdk']['archive_name']}"
    user "vagrant"
    group "vagrant"
    action :run
    notifies :run, "execute[install JDK]", :immediately
    not_if { File.exists?("#{node['jdk']['install_dir']}/#{node['jdk']['version']}") }
end


execute "install JDK" do
    cwd "/tmp"
    command <<-_EOF_
        mv #{node['jdk']['version']} #{node['jdk']['install_dir']}
        ln -s #{node['jdk']['install_dir']}/#{node['jdk']['version']} #{node['jdk']['install_dir']}/jdk
    _EOF_
    user "root"
    group "root"
    action :run
    not_if { File.exists?("#{node['jdk']['install_dir']}/#{node['jdk']['version']}") }
end


