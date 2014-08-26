module CampaignSpreadersHelper
  def campaign_progress campaign
    ((Time.now - campaign.created_at)/(campaign.ends_at - campaign.created_at)) * 100
  end
end
