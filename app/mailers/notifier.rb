class Notifier < ActionMailer::Base
  default from: "from@example.com"
  layout "mail"

  def new_spreader campaign_spreader
    @user = campaign_spreader.timeline.user
    @campaign = campaign_spreader.campaign
    @organization = @campaign.organization
    mail(to: @user.email, subject: @campaign.title, from: @campaign.user.email)
  end
end
