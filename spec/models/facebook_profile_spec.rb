require 'rails_helper'

RSpec.describe FacebookProfile, :type => :model do
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :token }
  it { should validate_presence_of :expires_at }

  context "when there is one Facebook profile" do
    before { FacebookProfile.make! }
    it { should validate_uniqueness_of :uid }
    it { should validate_uniqueness_of :user_id }
  end

  describe "#service" do
    before { FacebookProfile.make! }
    it "should be facebook" do
      expect(subject.service).to eq(:facebook)
    end
  end

  describe "#fetch_friends_count" do
    subject { FacebookProfile.make! }

    context "when it's a valid credential" do
      it "should update friends_count" do
        expect {
          VCR.use_cassette('facebook 861 friends', match_requests_on: [:host, :path]) do
            subject.fetch_friends_count
          end
        }.to change{subject.friends_count}.from(nil).to(861)
      end
    end

    context "when it's an invalid credential" do
      it "should not update friends_count" do
        expect {
          VCR.use_cassette('invalid credential', match_requests_on: [:host]) do
            subject.fetch_friends_count
          end
        }.to_not change{subject.friends_count}
      end
    end
  end

  describe "#fetch_subscribers_count" do
    subject { FacebookProfile.make! }

    context "when it's a valid credential" do
      it "should update subscribers_count" do
        expect {
          VCR.use_cassette('facebook 65 subscribers', match_requests_on: [:host, :path]) do
            subject.fetch_subscribers_count
          end
        }.to change{subject.subscribers_count}.from(nil).to(65)
      end
    end

    context "when it's an invalid credential" do
      it "should not update subscribers_count" do
        expect {
          VCR.use_cassette('invalid credential', match_requests_on: [:host]) do
            subject.fetch_subscribers_count
          end
        }.to_not change{subject.subscribers_count}
      end
    end
  end

  describe "#check_expired_token" do
    subject { FacebookProfile.make! }

    context "when the token is not expired" do
      it "should not change the expires_at attribute" do
        expect {
          VCR.use_cassette('facebook valid token', match_requests_on: [:host, :path]) do
            subject.check_expired_token
          end
        }.to_not change{subject.expires_at}
      end
    end

    context "when the token is expired" do
      it "should update the expires_at attribute" do
        expect {
          VCR.use_cassette('facebook expired token', match_requests_on: [:host, :path]) do
            subject.check_expired_token
          end
        }.to change{subject.expires_at}
      end
    end
  end

  describe "#share" do
    let(:campaign_spreader){ CampaignSpreader.make!(:facebook_profile) }
    subject { campaign_spreader.timeline }

    context "when it's a valid credential" do
      it "should update campaign_spreader#uid" do
        expect {
          VCR.use_cassette('facebook profile share', match_requests_on: [:host, :path]) do
            subject.share campaign_spreader
          end
        }.to change{campaign_spreader.uid}.from(nil).to("10152278257287843_10152330512207843")
      end
    end

    context "when it's an invalid credential" do
      it "should not update campaign_spreader#uid" do
        expect {
          VCR.use_cassette('invalid credential', match_requests_on: [:host]) do
            subject.share campaign_spreader
          end
        }.to_not change{campaign_spreader.uid}
      end
    end
  end
end
