require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  it { should have_many :campaign_spreaders }

  describe ".unshared" do
    context "when there is at least one unshared campaign" do
      before { Campaign.make! }

      it "should have one campaign" do
        expect(Campaign.unshared).to have(1).campaign
      end
    end

    context "when there is no unshared campaign" do
      before { Campaign.make! shared_at: Time.now }

      it "should be empty" do
        expect(Campaign.unshared).to be_empty
      end
    end
  end

  describe "#share" do
    subject { Campaign.make! }
    before { @campaign_spreader = CampaignSpreader.make!(:facebook_profile, campaign: subject) }

    it "should call campaign_spreader#share method" do
      expect{
        VCR.use_cassette('facebook profile share', match_requests_on: [:host, :path]) do
          subject.share
        end
      }.to change{@campaign_spreader.reload.uid}.from(nil).to("10152278257287843_10152330512207843")
    end

    it "should update shared_at" do
      time = Time.now
      allow(Time).to receive(:now).and_return(time)

      expect{
        subject.share
      }.to change{subject.shared_at}.from(nil).to(time)
    end
  end
end
