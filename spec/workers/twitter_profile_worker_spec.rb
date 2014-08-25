require 'rails_helper'

RSpec.describe TwitterProfileWorker, :type => :worker do
  describe "#perform" do
    let(:twitter_profile) do
      double(
        "twitter_profile",
        id: 1,
        fetch_followers_count: true
      )
    end

    before { allow(TwitterProfile).to receive(:find).with(twitter_profile.id).and_return(twitter_profile) }

    it "should fetch followers count" do
      expect(twitter_profile).to receive(:fetch_followers_count)
      subject.perform(twitter_profile.id)
    end
  end
end
