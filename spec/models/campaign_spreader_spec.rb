require 'rails_helper'

RSpec.describe CampaignSpreader, :type => :model do
  it { should belong_to :timeline }
  it { should belong_to :campaign }
  it { should validate_presence_of :timeline_id }
  it { should validate_presence_of :timeline_type }
  it { should validate_presence_of :campaign_id }

  context "when there is one campaign spreader" do
    before { CampaignSpreader.make!(:facebook_profile) }
    it { should validate_uniqueness_of(:timeline_id).scoped_to([:timeline_type, :campaign_id]) }
  end

  describe "#share" do
    subject { CampaignSpreader.make!(:facebook_profile) }

    it "should call facebook_profile#share method" do
      expect(subject.timeline).to receive(:share)
      subject.share
    end
  end
end
