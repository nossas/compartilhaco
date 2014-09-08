class CampaignsController < ApplicationController
  respond_to :html, :json

  def index
    @campaigns = Campaign.unarchived.upcoming
  end

  def show
    @campaign = Campaign.find(params[:id])
    @last_spreaders = @campaign.campaign_spreaders.order(created_at: :desc).limit(5)
    @campaign_spreader = CampaignSpreader.new(campaign: @campaign)
  end

  def archive
    @campaign = Campaign.find(params[:id])
    @campaign.archive
    respond_with @campaign
  end

  def serve_image
    @campaign = Campaign.find(params[:id])
    data = open(@campaign.image.path).read
    send_data data, type: MIME::Types.type_for(@campaign.image.url).first.content_type, disposition: 'inline'
  end
end
