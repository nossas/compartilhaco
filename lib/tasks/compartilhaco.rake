namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      Campaign.upcoming.each { |c| c.check_expired_tokens }
    end
  end

  task :share_campaigns => :environment do
    Campaign.unarchived.unshared.ended.succeeded.each { |c| c.share }
  end
end
