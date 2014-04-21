#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: hbase
#
# All rights reserved - Do Not Redistribute
#

if File.exists?("/vagrant/#{node['hbase']['archive_name']}")
    execute "copy #{node['hbase']['archive_name']}" do
        command "cp /vagrant/#{node['hbase']['archive_name']} /tmp"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hbase]", :immediately
        not_if { File.exists?("#{node['hbase']['install_dir']}/hbase-#{node['hbase']['version']}") }
    end
else
    execute "download hbase" do
        cwd "/tmp"
        command "curl -L -O #{node['hbase']['url']}"
        user "vagrant"
        group "vagrant"
        action :run
        notifies :run, "execute[untar hbase]", :immediately
        not_if { File.exists?("#{node['hbase']['install_dir']}/hbase-#{node['hbase']['version']}") }
    end
end


execute "untar hbase" do
    cwd "/tmp"
    command "tar zxf #{node['hbase']['archive_name']}"
    user "vagrant"
    group "vagrant"
    action :run
    notifies :run, "execute[install hbase]", :immediately
    not_if { File.exists?("#{node['hbase']['install_dir']}/hbase-#{node['hbase']['version']}") }
end


execute "install hbase" do
    cwd "/tmp"
    command <<-_EOF_
        mv hbase-#{node['hbase']['version']} #{node['hbase']['install_dir']}
        ln -s #{node['hbase']['install_dir']}/hbase-#{node['hbase']['version']} #{node['hbase']['install_dir']}/hbase
    _EOF_
    user "root"
    group "root"
    action :run
    not_if { File.exists?("#{node['hbase']['install_dir']}/hbase-#{node['hbase']['version']}") }
end

template "#{node['hbase']['install_dir']}/hadoop/conf/hbase-site.xml" do
    source "hbase-site.xml.erb"
    group "vagrant"
    owner "vagrant"
    mode "0644"
end

# -----------------------------------------
# start hbase

#execute "start hbase" do
#    command "#{node['hbase']['install_dir']}/hadoop/bin/start-all.sh"
#    user "vagrant"
#    group "vagrant"
#    action :run
#end

