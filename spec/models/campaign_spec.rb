require 'rails_helper'

RSpec.describe Campaign, :type => :model do
  it { should have_many :campaign_spreaders }

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
