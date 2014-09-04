class Notifier < ActionMailer::Base
  default from: "from@example.com"

  def new_spreader campaign_spreader
    @user = campaign_spreader.timeline.user
    @campaign = campaign_spreader.campaign
    mail(to: @user.email, subject: @campaign.title, from: @campaign.user.email)
  end
end
