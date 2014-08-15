class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.find(params[:id])
    @facebook_profile_campaign_spreader = CampaignSpreader.new(campaign: @campaign)
  end
end
