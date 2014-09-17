namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      Campaign.upcoming.each { |c| c.check_expired_tokens }
    end
  end
end
