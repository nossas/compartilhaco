require 'rails_helper'

RSpec.describe CampaignWorker, :type => :worker do
  describe "#perform" do
    let(:campaign) { Campaign.make! }

    it "should deliver the new campaign email" do
      new_campaign_email = double("new_campaign_email")
      allow(Notifier).to receive(:new_campaign).with(campaign).and_return(new_campaign_email)
      expect(new_campaign_email).to receive(:deliver)
      subject.perform(campaign.id)
    end
  end
end
