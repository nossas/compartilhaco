require 'rails_helper'

RSpec.describe CampaignSpreaderWorker, :type => :worker do
  describe "#perform" do
    let(:campaign_spreader) { double("campaign_spreader", id: 1) }
    before { allow(CampaignSpreader).to receive(:find).with(campaign_spreader.id).and_return(campaign_spreader) }

    it "should create segment subscription" do
      expect(campaign_spreader).to receive(:create_segment_subscription)
      subject.perform(campaign_spreader.id)
    end
  end
end
