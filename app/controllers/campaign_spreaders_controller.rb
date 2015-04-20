class CampaignSpreadersController < ApplicationController
  before_filter only: [:create_for_facebook_profile, :create_for_twitter_profile] do
    session[:campaign_spreader] = campaign_spreader_params if campaign_spreader_params.present?
  end

  before_filter only: [:create_for_facebook_profile_callback, :create_for_twitter_profile_callback] do
    @auth_params = request.env['omniauth.auth']
    @campaign_spreader_params = session.delete(:campaign_spreader)
    @campaign = Campaign.find(@campaign_spreader_params["campaign_id"])

    @user = current_user || User.find_by_email(@campaign_spreader_params["timeline"]["user"]["email"]) || User.create(
      first_name: @auth_params[:info][:first_name] || @auth_params[:info][:name].split(" ")[0],
      last_name: @auth_params[:info][:last_name] || @auth_params[:info][:name].split(" ")[-1],
      email: @campaign_spreader_params["timeline"]["user"]["email"],
      ip: request.remote_ip,
      password: SecureRandom.hex,
      organization_id: @campaign.organization_id.to_s
    )
  end

  def create_for_facebook_profile_callback
    facebook_profile = FacebookProfile.find_or_initialize_by(uid: @auth_params[:uid])
    facebook_profile.update_attributes(
      user_id: @user.id,
      uid: @auth_params[:uid],
      expires_at: Time.at(@auth_params[:credentials][:expires_at]),
      token: @auth_params[:credentials][:token]
    )

    CampaignSpreader.create @campaign_spreader_params.merge(timeline: facebook_profile)

    redirect_to twitter_form_campaign_path(@campaign_spreader_params["campaign_id"], anchor: "share")
  end

  def create_for_twitter_profile_callback
    twitter_profile = TwitterProfile.find_or_initialize_by(uid: @auth_params[:uid])
    twitter_profile.update_attributes(
      user_id: @user.id,
      uid: @auth_params[:uid],
      token: @auth_params[:credentials][:token],
      secret: @auth_params[:credentials][:secret]
    )

    CampaignSpreader.create @campaign_spreader_params.merge(timeline: twitter_profile)

    redirect_to campaign_path(@campaign_spreader_params["campaign_id"], anchor: "share")
  end

  def create_for_facebook_profile
    redirect_to '/auth/facebook?scope=publish_actions,user_friends'
  end

  def create_for_twitter_profile
    redirect_to '/auth/twitter'
  end

  def failure
    redirect_to Campaign.first, alert: "Você não cedeu as permissões necessárias"
  end

  def campaign_spreader_params
    params.require(:campaign_spreader).permit(:campaign_id, :message, timeline: {user: :email})
  end
end
