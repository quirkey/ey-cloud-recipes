execute "testing" do
  command %Q{
    echo "i ran at #{Time.now}" >> /root/cheftime
  }
end

# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

if node[:instance_role] == 'db_master'
  require_recipe 'couchdb'
end

# uncomment to turn use the MBARI ruby patches for decreased memory usage and better thread/continuationi performance
# require_recipe "mbari-ruby"

# uncomment to turn on thinking sphinx 
# require_recipe "thinking_sphinx"

# uncomment to turn on ultrasphinx 
# require_recipe "ultrasphinx"

