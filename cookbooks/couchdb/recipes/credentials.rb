# create the couchdb yml
node[:applications].each do |app, data|
  directory "/data/#{app}/shared/config/couchdb.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    recursive true
  end
  
  template "/data/#{app}/shared/config/couchdb.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0700
    source "couchdb.yml.erb"
    variables({
      :env => node[:environment][:framework_env],
      :host => node[:db_host],
      :port => '5984',
      :username => 'admin',
      :password => node[:owner_pass]
      })  
  end
end