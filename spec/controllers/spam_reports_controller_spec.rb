require 'rails_helper'

RSpec.describe SpamReportsController, :type => :controller do
  describe "POST create" do
    before do
      allow(SpamReport).to receive(:create).with(campaign_id: "1", user_id: 1)
      allow(subject).to receive(:current_user).and_return(double("user", id: 1))
    end

    it "should redirect to the campaign page" do
      expect(
        post(:create, campaign_id: 1)
      ).to redirect_to(campaign_path(id: 1))
    end

    it "should call SpamReport.create" do
      expect(SpamReport).to receive(:create).with(campaign_id: "1", user_id: 1)
      post(:create, campaign_id: 1)
    end
  end
end
