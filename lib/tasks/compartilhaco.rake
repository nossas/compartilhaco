namespace :compartilhaco do
  namespace :facebook do
    task :check_expired_tokens => :environment do
      Campaign.upcoming.each { |c| c.check_expired_tokens }
    end
  end

  task :share_campaigns => :environment do
    Campaign.unarchived.unshared.ended.succeeded.each { |c| c.share }
  end

  task :send_expiring_alerts => :environment do
    Campaign.unarchived.expiring.where(delivered_expiring_alert: false).each do |c|
      Notifier.expiring_campaign_to_creator(c).deliver
      c.update_attribute :delivered_expiring_alert, true
    end
  end

  task :send_end_emails => :environment do
    Campaign.unarchived.ended.succeeded.where(end_emails_sent: false).each do |c|
      c.update_attribute :end_emails_sent, true
      c.campaign_spreaders.each do |cs|
        Notifier.succeed_campaign_to_spreaders(c, cs.user).deliver
      end
      Notifier.succeed_campaign_to_creator(c).deliver
    end
    Campaign.unarchived.ended.unsucceeded.where(end_emails_sent: false).each do |c|
      c.update_attribute :end_emails_sent, true
      c.campaign_spreaders.each do |cs|
        Notifier.unsucceed_campaign_to_spreaders(c, cs.user).deliver
      end
      Notifier.unsucceed_campaign_to_creator(c).deliver
    end
  end
end
