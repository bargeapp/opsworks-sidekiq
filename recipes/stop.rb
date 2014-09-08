node[:deploy].each do |application, deploy|
  execute "restart-sidekiq" do
    command %Q{
      echo "monit -g sidekiq_#{application} stop all" | at now
    }
  end
end