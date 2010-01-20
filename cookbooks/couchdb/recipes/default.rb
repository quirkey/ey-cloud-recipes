#
# Cookbook Name:: couchdb
# Recipe:: default
#

package "couchdb" do
  version "0.9.0"
end

directory "/db/couchdb/log" do
  owner "couchdb"
  group "couchdb"
  mode 0755
  recursive true
end

directory "/var/run/couchdb" do
  owner "couchdb"
  group "couchdb"
  mode 0755
  recursive true
end

template "/etc/couchdb/local.ini" do
  owner 'couchdb'
  group 'couchdb'
  mode 0644
  source "local.ini.erb"
  variables({
    :basedir => '/db/couchdb',
    :logfile => '/db/couchdb/log/couch.log',
    :bind_address => '0.0.0.0',
    :port  => '5984',
    :doc_root => '/usr/share/couchdb/www', # change if you have a cutom couch www root
    :driver_dir => '/usr/lib/couchdb/erlang/lib/couch-0.9.0/priv/lib', # this is good for the 0.8.1 build on our gentoo
    :loglevel => 'info',
    :admin_user => 'admin',
    :admin_pass => node[:owner_pass]
  })
end

remote_file "/etc/init.d/couchdb" do
  source "couchdb"
  owner "root"
  group "root"
  mode 0755
end

# execute "add-couchdb-to-default-run-level" do
#   command %Q{
#     rc-update add couchdb default
#   }
#   not_if "rc-status | grep couchdb"
# end
# 
# execute "ensure-couchdb-is-running" do
#   command %Q{
#     /etc/init.d/couchdb restart
#   }
#   # not_if "/etc/init.d/couchdb status | grep 'status:  started'"
# end