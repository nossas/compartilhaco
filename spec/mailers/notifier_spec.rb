require "rails_helper"

RSpec.describe Notifier, :type => :mailer do
  describe ".new_spreader" do
    let(:campaign_spreader){ CampaignSpreader.make!(:facebook_profile) }
    let(:organization) { campaign_spreader.campaign.organization }
    let(:email){ Notifier.new_spreader(campaign_spreader) }

    it "should send email to the spreader" do
      expect(email.to).to include(campaign_spreader.timeline.user.email)
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

  describe ".new_campaign" do
    let(:campaign){ Campaign.make! }
    let(:email){ Notifier.new_campaign(campaign) }

    it "should be sent to the campaign's creator" do
      expect(email.to).to include(campaign.user.email)
    end

    it "should contain the campaign's link" do
      expect(email.body).to match(campaign_url(campaign))
    end
  end

  describe ".unsucceed_campaign_to_spreaders" do
    let(:campaign){ Campaign.make! }
    let(:email){ Notifier.unsucceed_campaign_to_spreaders(campaign) }
    before{ CampaignSpreader.make! :facebook_profile, campaign: campaign }

    it "should be sent to all the campaign's spreaders" do
      expect(email.bcc).to be_eql(campaign.campaign_spreaders.map{|cs| cs.user.email})
    end

    it "should contain the campaign's link" do
      expect(email.body).to match(campaign_url(campaign))
    end
  end

  describe ".unsucceed_campaign_to_creator" do
    let(:campaign){ Campaign.make! }
    let(:email){ Notifier.unsucceed_campaign_to_creator(campaign) }

    it "should be sent to the campaign's creator" do
      expect(email.to).to include(campaign.user.email)
    end

    it "should contain the campaign's link" do
      expect(email.body).to match(campaign_url(campaign))
    end
  end

  describe ".succeed_campaign_to_spreaders" do
    let(:campaign){ Campaign.make! }
    let(:email){ Notifier.succeed_campaign_to_spreaders(campaign) }
    before{ CampaignSpreader.make! :facebook_profile, campaign: campaign }

    it "should be sent to all the campaign's spreaders" do
      expect(email.bcc).to be_eql(campaign.campaign_spreaders.map{|cs| cs.user.email})
    end

    it "should contain the campaign's link" do
      expect(email.body).to match(campaign_url(campaign))
    end
  end

  describe ".succeed_campaign_to_creator" do
    let(:campaign){ Campaign.make! }
    let(:email){ Notifier.succeed_campaign_to_creator(campaign) }

    it "should be sent to the campaign's creator" do
      expect(email.to).to include(campaign.user.email)
    end

    it "should contain the campaign's link" do
      expect(email.body).to match(campaign_url(campaign))
    end
  end
end
