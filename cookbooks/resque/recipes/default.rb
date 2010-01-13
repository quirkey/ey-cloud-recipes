#
# Cookbook Name:: resque
# Recipe:: default
#

require_recipe "monit::default"
require_recipe "redis::default"

gem_package "redis" do 
  source "http://gemcutter.org"
  action :install
end  

gem_package "redis-namespace" do 
  source "http://gemcutter.org"
  action :install
end  

gem_package "resque" do 
  source "http://gemcutter.org"
  action :install
end  

remote_file "/usr/local/bin/resque" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  source "resque"
end

node[:applications].each do |app, data|
  template "/etc/monit.d/resque_#{app}.conf" do
    owner 'root'
    group 'root'
    mode 0600
    source "monit.conf.erb"
    variables({
      :num_workers => 2,
      :app_name => app,
      :rails_env => node[:environment][:framework_env]
    })  
    notifies :run, resources(:execute => "restart-monit")
  end
end

