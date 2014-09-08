node[:deploy].each do |application, deploy|
  next unless deploy[:sidekiq]
  exec "monit stop sidekiq_#{application}"
end