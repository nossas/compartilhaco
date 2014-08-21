require 'rails_helper'

RSpec.describe CampaignSpreader, :type => :model do
  it { should belong_to :timeline }
  it { should belong_to :campaign }
  it { should validate_presence_of :timeline_id }
  it { should validate_presence_of :timeline_type }
  it { should validate_presence_of :campaign_id }

  context "when it's a Facebook timeline" do
    subject { CampaignSpreader.make(:facebook_profile) }
    it { should ensure_length_of(:message).is_at_most(140) }
  end

  context "when it's not a Facebook timeline" do
    subject { CampaignSpreader.make(:twitter_profile) }
    it { should_not ensure_length_of(:message).is_at_most(140) }
  end

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
