#
# Cookbook Name:: Standalone-Hadoop
# Recipe:: default
#
# All rights reserved - Do Not Redistribute
#

execute "ssh setting" do
    cwd node['vagrant']['home_dir']
    command <<-_EOF_
        ssh-keygen -t rsa -N '' -f #{node['vagrant']['home_dir']}/.ssh/id_rsa
        cat .ssh/id_rsa.pub >> .ssh/authorized_keys
        chmod 600 .ssh/authorized_keys
    _EOF_
    user "vagrant"
    group "vagrant"
    action :run
end

cookbook_file "#{node['vagrant']['home_dir']}/.ssh/config" do
    source "config"
    group "vagrant"
    owner "vagrant"
    mode "0600"
end
