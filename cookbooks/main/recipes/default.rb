execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/cheftime
  }
end

# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

if node[:instance_role] == 'db_master'
  require_recipe 'couchdb::default'
end

if node[:instance_role] =~ /^app/ 
  require_recipe 'resque::init'
  require_recipe 'couchdb::credentials'
end

if node[:instance_role] == 'app_master'
  require_recipe 'redis::default'
  require_recipe 'resque::default'
end

# uncomment to turn use the MBAR  I ruby patches for decreased memory usage and better thread/continuationi performance
# require_recipe "mbari-ruby"

# uncomment to turn on thinking sphinx 
# require_recipe "thinking_sphinx"

# uncomment to turn on ultrasphinx 
# require_recipe "ultrasphinx"

