require 'rails_helper'

RSpec.describe CampaignShareWorker, :type => :worker do
  describe "#perform" do
    before { @campaign = Campaign.make! }
    before { CampaignSpreader.make! :facebook_profile, campaign: @campaign }
    before { allow(Campaign).to receive(:find).with(@campaign.id).and_return @campaign }
    before { allow(@campaign).to receive(:archived?).and_return false }
    before { allow(@campaign).to receive(:shared?).and_return false }

    context "when the campaign is succeeded" do
      before { allow(@campaign).to receive(:succeeded?).and_return true }

      it "should call campaign#share method" do
        expect(@campaign).to receive(:share)
        subject.perform @campaign.id
      end

      it "should call Notifier.succeed_campaign_to_spreaders method" do
        email = double("succeed_campaign_to_spreaders")
        allow(Notifier).to receive(:succeed_campaign_to_spreaders).with(@campaign).and_return(email)
        expect(email).to receive(:deliver)
        subject.perform @campaign.id
      end

      it "should call Notifier.succeed_campaign_to_spreaders method" do
        email = double("succeed_campaign_to_creator")
        allow(Notifier).to receive(:succeed_campaign_to_creator).with(@campaign).and_return(email)
        expect(email).to receive(:deliver)
        subject.perform @campaign.id
      end
    end

    context "when the campaign is unsucceeded" do
      before { allow(@campaign).to receive(:unsucceeded?).and_return true }

      it "should call Notifier.unsucceed_campaign_to_spreaders method" do
        email = double("unsucceed_campaign_to_spreaders")
        allow(Notifier).to receive(:unsucceed_campaign_to_spreaders).with(@campaign).and_return(email)
        expect(email).to receive(:deliver)
        subject.perform @campaign.id
      end

      it "should call Notifier.unsucceed_campaign_to_spreaders method" do
        email = double("unsucceed_campaign_to_spreaders")
        allow(Notifier).to receive(:unsucceed_campaign_to_spreaders).with(@campaign).and_return(email)
        expect(email).to receive(:deliver)
        subject.perform @campaign.id
      end
    end
  end
end
