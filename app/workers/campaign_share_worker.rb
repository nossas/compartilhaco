class CampaignShareWorker
  include Sidekiq::Worker

  def perform campaign_id
    campaign = Campaign.find(campaign_id)
    if campaign.succeeded? && !campaign.archived? && !campaign.shared?
      campaign.share
      Notifier.succeed_campaign_to_spreaders(campaign).deliver
      Notifier.succeed_campaign_to_creator(campaign).deliver
    elsif campaign.unsucceeded? && !campaign.archived? && !campaign.shared?
      Notifier.unsucceed_campaign_to_spreaders(campaign).deliver
      Notifier.unsucceed_campaign_to_creator(campaign).deliver
    end
  end
end
