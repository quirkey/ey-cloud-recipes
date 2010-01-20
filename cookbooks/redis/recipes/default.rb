#
# Cookbook Name:: redis
# Recipe:: default
#


bash "install_redis" do
  user "root"
  cwd "/tmp"
  code <<-EOBASH
    wget http://redis.googlecode.com/files/redis-1.2.0.tar.gz
    tar xzf redis-1.2.0.tar.gz
    cd redis-1.2.0
    make
    cd ..
    mv redis-1.2.0 /usr/local/redis
    ln -nfs /usr/local/redis/redis-server /usr/bin/redis-server
  EOBASH
  not_if "test -d /usr/local/redis"
end

directory "/db/redis" do
  owner "redis"
  group "redis"
  mode 0755
  recursive true
end

port        = 6379
pid_file    = "/var/run/redis.#{port}.conf"
config_file = "/etc/redis.#{port}.conf"
bin_path    = "/usr/bin/redis-server"


template config_file do
  owner 'redis'
  group 'redis'
  mode 0644
  source "redis.conf.erb"
  variables({
    :pid_file => pid_file,
    :port => port,
    :db_file => 'dump.rdb',
    :db_path => '/db/redis/'
  })
end

template "/etc/init.d/redis" do
  source "redis_init.erb"
  owner "root"
  group "root"
  mode 0755
  variables({
    :pid_file => pid_file,
    :config_file => config_file,
    :bin_path => bin_path,
    :port => port
  })
end

execute "add-redis-to-default-run-level" do
  command %Q{
    rc-update add redis default
  }
  not_if "rc-status | grep redis"
end

execute "ensure-redis-is-running" do
  command %Q{
    /etc/init.d/redis start
  }
end