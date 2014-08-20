require 'rails_helper'

RSpec.describe FacebookProfileWorker, :type => :worker do
  describe "#perform" do
    let(:facebook_profile) do
      double(
        "facebook_profile",
        id: 1,
        fetch_friends_count: true,
        fetch_subscribers_count: true
      )
    end

    before { allow(FacebookProfile).to receive(:find).with(facebook_profile.id).and_return(facebook_profile) }

    it "should fetch friends count" do
      expect(facebook_profile).to receive(:fetch_friends_count)
      subject.perform(facebook_profile.id)
    end

    it "should fetch subscribers count" do
      expect(facebook_profile).to receive(:fetch_subscribers_count)
      subject.perform(facebook_profile.id)
    end
  end
end
