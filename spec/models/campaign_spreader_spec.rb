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

    context "when it was not shared yet" do
      it "should call facebook_profile#share method" do
        expect(subject.timeline).to receive(:share)
        subject.share
      end
    end

    context "when it was already shared" do
      before { subject.update_attribute :uid, "123" }
      it "should not call facebook_profile#share method" do
        expect(subject.timeline).to_not receive(:share)
        subject.share
      end
    end
  end

  describe "#create_segment_subscription" do
    subject { CampaignSpreader.make!(:facebook_profile) }

    it "should call Accounts API" do
      ENV["ACCOUNTS_HOST"] = "http://accounts.meurio-staging.org.br"
      ENV["ACCOUNTS_API_TOKEN"] = "123"
      expect(HTTParty).to receive(:post).with(
        "#{ENV["ACCOUNTS_HOST"]}/users/#{subject.timeline.user_id}/segment_subscriptions.json",
        body: {
          token: ENV["ACCOUNTS_API_TOKEN"],
          segment_subscription: { segment_id: subject.campaign.mailchimp_segment_uid }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

      subject.create_segment_subscription
    end
  end
end
