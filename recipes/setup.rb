node[:deploy].each do |application, deploy|

  Chef::Log.info("Configuring sidekiq for application #{application}")

  template "/etc/init/sidekiq-#{application}.conf" do
    source "sidekiq.conf.erb"
    mode '0644'
    variables deploy: deploy
  end

  settings = node[:sidekiq][application]
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