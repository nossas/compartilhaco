require 'rails_helper'

RSpec.describe CampaignSpreaderWorker, :type => :worker do
  describe "#perform" do
    let(:campaign_spreader) { CampaignSpreader.make!(:facebook_profile) }
    before { allow(CampaignSpreader).to receive(:find).with(campaign_spreader.id).and_return(campaign_spreader) }
    before { allow(campaign_spreader).to receive(:create_segment_subscription) }

    it "should create segment subscription" do
      expect(campaign_spreader).to receive(:create_segment_subscription)
      subject.perform(campaign_spreader.id)
    end

    it "should deliver the new spreader mail" do
      new_spreader_mail = double("new_spreader_mail")
      allow(NotificationMailer).to receive(:new_spreader).with(campaign_spreader).and_return(new_spreader_mail)
      expect(new_spreader_mail).to receive(:deliver)
      subject.perform(campaign_spreader.id)
    end
  end
end
