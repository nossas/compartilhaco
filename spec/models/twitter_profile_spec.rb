require 'rails_helper'

RSpec.describe TwitterProfile, :type => :model do
  it { should belong_to :user }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :uid }

  context "when there is one Twitter profile" do
    before { TwitterProfile.make! }
    it { should validate_uniqueness_of :user_id }
    it { should validate_uniqueness_of :uid }
  end
end
