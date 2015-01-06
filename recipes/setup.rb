node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring sidekiq for application #{application}")

  template "/etc/init/sidekiq-#{application}.conf" do
    source "sidekiq.conf.erb"
    mode '0644'
    variables deploy: deploy
  end

  layer = node[:opsworks][:instance][:layers].first

  # first get layer-specific settings
  settings = node[:sidekiq][layer]

  # fall back on application-specific settings
  settings = node[:sidekiq][application] if settings.nil?

  # configure rails_env in case of non-rails app
  rack_env = deploy[:rails_env] || settings[:rack_env] || settings[:rails_env]
  instances = settings[:instances] || 1

  instances.times do |idx|
    idx = idx + 1
    template "/etc/init/sidekiq-#{application}-#{idx}.conf" do
      source "sidekiq-n.conf.erb"
      mode '0644'
      variables application: application, instance: idx, rack_env: rack_env, deploy: deploy, settings: settings
    end
  end
end