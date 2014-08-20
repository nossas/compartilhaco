class CampaignSpreadersController < ApplicationController
  before_filter except: [:failure] do
    @auth_params = request.env['omniauth.auth']
    @campaign_spreader_params = session.delete(:campaign_spreader)
  end

  def create_for_facebook_profile
    if @auth_params.nil?
      session[:campaign_spreader] = params[:campaign_spreader]
      redirect_to '/auth/facebook?scope=publish_actions,user_friends'
    else
      user = current_user || User.find_by_email(@campaign_spreader_params["timeline"]["user"]["email"])
      user = User.create(
        email: @campaign_spreader_params["timeline"]["user"]["email"],
        first_name: @auth_params[:info][:first_name],
        last_name: @auth_params[:info][:last_name],
        ip: request.remote_ip
      ) if user.nil?

      facebook_profile = FacebookProfile.find_or_initialize_by(uid: @auth_params[:uid])
      facebook_profile.update_attributes(
        user_id: user.id,
        uid: @auth_params[:uid],
        expires_at: Time.at(@auth_params[:credentials][:expires_at]),
        token: @auth_params[:credentials][:token]
      )

      CampaignSpreader.create @campaign_spreader_params.merge(timeline: facebook_profile)

      redirect_to campaign_path(@campaign_spreader_params["campaign_id"]), notice: "Pronto! Obrigado por se juntar a este compartilhaço"
    end
  end

  def create_for_twitter_profile
    if @auth_params.nil?
      session[:campaign_spreader] = params[:campaign_spreader]
      redirect_to '/auth/twitter'
    else
      user = User.create(
        email: @campaign_spreader_params["timeline"]["user"]["email"],
        ip: request.remote_ip
      )

      twitter_profile = TwitterProfile.create(
        user: user,
        uid: @auth_params[:uid]
      )

      CampaignSpreader.create @campaign_spreader_params.merge(timeline: twitter_profile)

      redirect_to campaign_path(@campaign_spreader_params["campaign_id"]), notice: "Pronto! Obrigado por se juntar a este compartilhaço"
    end
  end

  def failure
    redirect_to Campaign.first, alert: "Você não cedeu as permissões necessárias"
  end
end
