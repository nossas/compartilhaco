require "rails_helper"

RSpec.describe NotificationMailer, :type => :mailer do
  describe ".new_spreader" do
    let(:campaign_spreader){ CampaignSpreader.make!(:facebook_profile) }
    let(:email){ NotificationMailer.new_spreader(campaign_spreader) }

    it "should send email to the spreader" do
      expect(email.to).to include(campaign_spreader.timeline.user.email)
    end

    it "should use the campaign title as the mail title" do
      expect(email.subject).to be_eql(campaign_spreader.campaign.title)
    end

    it "should contain user name in the mail body" do
      expect(email.body).to match(campaign_spreader.timeline.user.name)
    end
  end
end
