class CampaignsController < ApplicationController
  def show
    @campaign = Campaign.find(params[:id])
    @facebook_profile_campaign_spreader = CampaignSpreader.new(campaign: @campaign)
  end

  def serve_image
    @campaign = Campaign.find(params[:id])
    send_file @campaign.image.path, type: MIME::Types.type_for(@campaign.image.url).first.content_type, disposition: "inline"
  end
end
