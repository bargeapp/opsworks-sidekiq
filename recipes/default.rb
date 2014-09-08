node[:deploy].each do |application, deploy|
  next unless deploy[:sidekiq]

  template "/etc/monit.d/sidekiq_#{application}.monitrc" do
    mode 0644
    source "sidekiq.monitrc.erb"
    variables({
      application: application,
      user: "#{deploy[:user]}",
      current_path: "#{deploy[:current_path]}",
      rails_env: "#{deploy[:rails_env]}",
      pid_file: "#{deploy[:deploy_to]}/shared/pids/sidekiq.pid",
      conf_file: "#{deploy[:deploy_to]}/current/config/sidekiq.yml",
      log_file: "#{deploy[:deploy_to]}/shared/log/sidekiq.log",
    })
    
    exec "monit start sidekiq_#{application}"
  end
end