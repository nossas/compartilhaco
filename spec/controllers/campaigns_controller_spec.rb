require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do
  describe "GET show" do
    let(:campaign){ Campaign.make! }
    before { get :show, id: campaign.id }

    it "should assign @campaign_spreader" do
      expect(assigns(:campaign_spreader)).to be_instance_of(CampaignSpreader)
    end

    it "should assign @campaign" do
      expect(assigns(:campaign)).to be_eql(campaign)
    end

    context "when there are no spreaders" do
      it "should assign empty to @last_spreaders" do
        expect(assigns(:last_spreaders)).to be_empty
      end
    end

    context "when there are 5 spreaders" do
      before { 5.times { CampaignSpreader.make! :facebook_profile, campaign: campaign } }

      it "should assign 5 items to @last_spreaders" do
        expect(assigns(:last_spreaders).count).to eq(5)
      end
    end
  end

  describe "GET serve_image" do
    let(:campaign){ Campaign.make! }

    it "should serve an image" do
      get :serve_image, id: campaign.id, trash: 'blablabla'
      expect(response.header["Content-Type"]).to eq "image/jpeg"
    end
  end
end
