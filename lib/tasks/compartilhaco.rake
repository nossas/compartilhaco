namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      Campaign.upcoming.each { |c| c.check_expired_tokens }
    end
  end

  task :share_campaigns => :environment do
    Campaign.unarchived.unshared.ended.succeeded.each { |c| c.share }
  end

  task :send_end_emails => :environment do
    Campaign.unarchived.ended.succeeded.where(end_emails_sent: false).each do |c|
      Notifier.succeed_campaign_to_spreaders(c).deliver
      Notifier.succeed_campaign_to_creator(c).deliver
      c.update_attribute :end_emails_sent, true
    end
    Campaign.unarchived.ended.unsucceeded.where(end_emails_sent: false).each do |c|
      Notifier.unsucceed_campaign_to_spreaders(c).deliver
      Notifier.unsucceed_campaign_to_creator(c).deliver
      c.update_attribute :end_emails_sent, true
    end
  end
end
