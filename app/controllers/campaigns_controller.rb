class CampaignsController < ApplicationController
  def show
    @facebook_profile_campaign_spreader = CampaignSpreader.new
  end
end
