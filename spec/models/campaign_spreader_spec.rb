require 'rails_helper'

RSpec.describe CampaignSpreader, :type => :model do
  it { should belong_to :timeline }
  it { should belong_to :campaign }

  describe "#share" do
    subject { CampaignSpreader.make!(:facebook_profile) }

    it "should call facebook_profile#share method" do
      expect(subject.timeline).to receive(:share)
      subject.share
    end
  end
end
