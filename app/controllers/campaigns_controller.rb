class CampaignsController < ApplicationController
  load_and_authorize_resource except: [:serve_image]
  respond_to :html, :json

  def index
    @campaigns = Campaign
      .unarchived
      .upcoming_or_shared
      .order(:ends_at)
      .page(params[:page])
      .per(9)
  end

  def show
    @campaign = Campaign.find(params[:id])
    @last_spreaders = @campaign.campaign_spreaders.order(created_at: :desc).limit(5)
    @campaign_spreader = CampaignSpreader.new(campaign: @campaign)
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user

    if @campaign.save
      respond_with @campaign, notice: 'Campanha criada!'
    else
      render :new
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
  end

  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update(campaign_params)
      respond_with @campaign, notice: 'Campanha atualizada!'
    else
      render :edit
    end
  end

  def archive
    @campaign = Campaign.find(params[:id])
    @campaign.archive
    respond_with @campaign
  end

  def serve_image
    @campaign = Campaign.find(params[:id])
    send_data(
      @campaign.facebook_image.file.read,
      type: MIME::Types.type_for(@campaign.facebook_image.path).first.content_type,
      disposition: 'inline'
    )
  end

  def campaign_params
    params.fetch(:campaign, {}).permit(:title, :description, :image, :ends_at, :goal, :organization_id, :user_id, :category_id, :share_link, :tweet, :new_campaign_spreader_mail, :hashtag, :facebook_title, :facebook_message, :facebook_image, :meta_title, :meta_message, :meta_image, :short_description)
  end
end
