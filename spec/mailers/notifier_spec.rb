require "rails_helper"

RSpec.describe Notifier, :type => :mailer do
  describe ".new_spreader" do
    let(:campaign_spreader){ CampaignSpreader.make!(:facebook_profile) }
    let(:organization) { campaign_spreader.campaign.organization }
    let(:email){ Notifier.new_spreader(campaign_spreader) }

    it "should send email to the spreader" do
      expect(email.to).to include(campaign_spreader.timeline.user.email)
    end

    it "should use the campaign title as the mail title" do
      expect(email.subject).to be_eql(campaign_spreader.campaign.title)
    end

    it "should contain user name in the mail body" do
      expect(email.body).to match(campaign_spreader.timeline.user.name)
    end

    it "should assign @organization" do
      expect(email.body).to match(organization.email_signature_html)
    end
  end

  describe ".new_spam_report" do
    let(:spam_report){ SpamReport.make! }
    let(:email){ Notifier.new_spam_report(spam_report) }

    it "should be sent to the tech team" do
      expect(email.to).to include(ENV["TECH_TEAM_EMAIL"])
    end

    it "should come from the reporter" do
      expect(email.from).to include(spam_report.user.email)
    end

    it "should contain a link for the reported campaign" do
      expect(email.body).to match(campaign_url(spam_report.campaign))
    end
  end
end
