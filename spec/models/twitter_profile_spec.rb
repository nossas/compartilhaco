require 'rails_helper'

RSpec.describe TwitterProfile, :type => :model do
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :token }
  it { should validate_presence_of :secret }

  context "when there is one Twitter profile" do
    before { TwitterProfile.make! }
    it { should validate_uniqueness_of :user_id }
    it { should validate_uniqueness_of :uid }
  end

  describe "#fetch_followers_count" do
    subject { TwitterProfile.make! }

    context "when it's a valid credential" do
      it "should update followers_count" do
        expect {
          VCR.use_cassette('twitter 415 followers', match_requests_on: [:host, :path]) do
            subject.fetch_followers_count
          end
        }.to change{subject.followers_count}.from(nil).to(415)
      end
    end

    context "when it's an invalid credential" do
      it "should not update followers_count" do
        expect {
          VCR.use_cassette('invalid twitter credentials', match_requests_on: [:host]) do
            subject.fetch_followers_count
          end
        }.to_not change{subject.followers_count}
      end
    end
  end
end
