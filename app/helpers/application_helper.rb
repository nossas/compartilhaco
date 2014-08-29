module ApplicationHelper
  def campaign_timelines_target_progress campaign
    ((campaign.campaign_spreaders.count.to_f/campaign.timelines_target.to_f) * 100).to_i
  end

  def campaign_ends_at_progress campaign
    ((Time.now - campaign.created_at)/(campaign.ends_at - campaign.created_at) * 100).to_i
  end

  def user_path user
    "#{ENV['MEURIO_HOST']}/users/#{user.id}"
  end
end
