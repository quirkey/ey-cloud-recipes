node[:applications].each do |app, data|  
  template "/data/#{app}/shared/config/resque.rb" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    source "initializer.rb.erb"
    variables({
      :redis_path => "#{node[:master_app_server][:private_dns_name]}:6379",
      :expire_in => (14 * 24 * 60 * 60) # 2 weeks
    })
  end
end