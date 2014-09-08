include_recipe "opsworks_nodejs::create_env_file"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  Chef::Log.info("Configuring sidekiq for application #{application}")

  settings = node[:sidekiq][application]
  workers = settings && settings[:workers] ? settings[:workers] : 1

  template "#{deploy[:deploy_to]}/shared/scripts/sidekiq" do
    mode '0755'
    owner deploy[:user]
    group deploy[:group]
    source "sidekiq.service.erb"
    variables(:deploy => deploy, :application => application)
  end

  template "/etc/monit.d/sidekiq_#{application}.monitrc" do
    owner "root"
    group "root"
    mode '0644'
    source "sidekiq.monitrc.erb"
    variables({ :application => application, :deploy => deploy, :workers => workers })
  end

  execute "ensure-sidekiq-is-setup-with-monit" do
    command %Q{
      monit reload
    }
  end

  execute "restart-sidekiq" do
    command %Q{
      echo "sleep 20 && monit -g sidekiq_#{application} restart all" | at now
    }
  end
end