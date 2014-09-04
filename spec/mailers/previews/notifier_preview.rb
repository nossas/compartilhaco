class NotifierPreview < ActionMailer::Preview
  def new_spreader
    Notifier.new_spreader(CampaignSpreader.first)
  end
end
