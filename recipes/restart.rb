node[:deploy].each do |application, deploy|
  service "sidekiq-#{application}" do
    action [:stop, :start]
    provider Chef::Provider::Service::Upstart
  end
end
