module ApplicationHelper
  def campaign_progress campaign
    ((15.days.from_now - campaign.created_at)/(campaign.ends_at - campaign.created_at)) * 100
  end
end
