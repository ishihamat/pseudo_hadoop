#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: mahout
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/vagrant/#{node['mahout']['archive_name']}")
    execute "copy #{node['mahout']['archive_name']}" do
        command "cp /vagrant/#{node['mahout']['archive_name']} /tmp"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar mahout]", :immediately
        not_if { File.exists?("#{node['mahout']['install_dir']}/mahout-#{node['mahout']['version']}") }
    end
else
    execute "download mahout" do
        cwd "/tmp"
        command "curl -L -O #{node['mahout']['url']}"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar mahout]", :immediately
        not_if { File.exists?("#{node['mahout']['install_dir']}/mahout-#{node['mahout']['version']}") }
    end
end


execute "untar mahout" do
    cwd "/tmp"
    command "tar zxf #{node['mahout']['archive_name']}"
    user "vagrant"
    group "vagrant"
    action :run
    notifies :run, "execute[install mahout]", :immediately
    not_if { File.exists?("#{node['mahout']['install_dir']}/mahout-#{node['mahout']['version']}") }
end


execute "install mahout" do
    cwd "/tmp"
    command <<-_EOF_
        mv mahout-distribution-#{node['mahout']['version']} #{node['mahout']['install_dir']}
        ln -s #{node['mahout']['install_dir']}/mahout-distribution-#{node['mahout']['version']} #{node['mahout']['install_dir']}/mahout
    _EOF_
    user "root"
    group "root"
    action :run
    not_if { File.exists?("#{node['mahout']['install_dir']}/mahout-distribution-#{node['mahout']['version']}") }
end

