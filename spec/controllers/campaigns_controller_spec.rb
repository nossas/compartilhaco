require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do
  describe "GET show" do
    let(:campaign){ Campaign.make! }

    it "should assign @campaign_spreader" do
      get :show, id: campaign.id
      expect(assigns(:campaign_spreader)).to be_instance_of(CampaignSpreader)
    end

    it "should assign @campaign" do
      get :show, id: campaign.id
      expect(assigns(:campaign)).to be_eql(campaign)
    end
  end
end
