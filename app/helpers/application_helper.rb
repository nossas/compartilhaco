module ApplicationHelper
  def campaign_progress campaign
    ((Time.now - campaign.created_at)/(campaign.ends_at - campaign.created_at)).to_i * 100
  end

  def user_path user
    "#{ENV['MEURIO_HOST']}/users/#{user.id}"
  end
end
