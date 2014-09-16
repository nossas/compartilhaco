class CampaignWorker
  include Sidekiq::Worker

  def perform campaign_id
    campaign = Campaign.find(campaign_id)
    Notifier.new_campaign(campaign).deliver
  end
end
