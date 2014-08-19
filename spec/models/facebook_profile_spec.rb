require 'rails_helper'

RSpec.describe FacebookProfile, :type => :model do
  it { should belong_to :user }

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
end
