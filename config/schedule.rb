env :PATH, ENV['PATH']
env :GEM_PATH, ENV['GEM_PATH']
set :output, "cron_log.log"

every 24.hours do
  rake :send_reminders
  rake :destroy_unpaid_reservations
  rake :set_regular_members
  rake :destroy_outdated_profiles
end

every '0 0 1 3 *' do
  rake :send_yearly_fee_reminder
end

every '0 0 1 9 *' do
  rake :recalculate_cost
end
