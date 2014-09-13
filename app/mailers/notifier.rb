class Notifier < ActionMailer::Base
  default from: "contato@minhascidades.org.br"
  layout "mail"

  def new_spreader campaign_spreader
    @user = campaign_spreader.timeline.user
    @campaign = campaign_spreader.campaign
    @organization = @campaign.organization
    mail(to: @user.email, subject: @campaign.title, from: @campaign.user.email)
  end

  def new_spam_report spam_report
    @user = spam_report.user
    @campaign = spam_report.campaign
    mail(to: ENV["TECH_TEAM_EMAIL"], subject: "[Compartilhaço] Nova denúncia", from: @user.email)
  end
end
