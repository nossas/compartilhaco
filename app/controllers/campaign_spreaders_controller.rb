class CampaignSpreadersController < ApplicationController
  def create_for_facebook_profile
    if params[:campaign_spreader]
      session[:campaign_spreader] = params[:campaign_spreader]
      redirect_to '/auth/facebook?scope=publish_actions,user_friends'
    elsif session[:campaign_spreader]
      auth = request.env['omniauth.auth']
      campaign_spreader = session.delete(:campaign_spreader)

      user = current_user || User.find_by_email(campaign_spreader["timeline"]["user"]["email"])
      user = User.create(
        email: campaign_spreader["timeline"]["user"]["email"],
        first_name: auth[:info][:first_name],
        last_name: auth[:info][:last_name],
        ip: request.remote_ip
      ) if user.nil?

      facebook_profile = FacebookProfile.find_or_initialize_by(uid: auth[:uid])
      facebook_profile.update_attributes(
        user_id: user.id,
        uid: auth[:uid],
        expires_at: Time.at(auth[:credentials][:expires_at]),
        token: auth[:credentials][:token]
      )

      CampaignSpreader.create(
        timeline: facebook_profile,
        campaign_id: campaign_spreader["campaign_id"],
        message: campaign_spreader["message"]
      )

      redirect_to Campaign.first, notice: "Pronto! Obrigado por se juntar a este compartilhaço"
    end
  end

  def create_for_twitter_profile
    if params[:campaign_spreader]
      session[:campaign_spreader] = params[:campaign_spreader]
      redirect_to '/auth/twitter'
    elsif session[:campaign_spreader]
      auth = request.env['omniauth.auth']
      campaign_spreader = session.delete(:campaign_spreader)

      user = User.create(
        email: campaign_spreader["timeline"]["user"]["email"],
        ip: request.remote_ip
      )

      twitter_profile = TwitterProfile.create(
        user: user,
        uid: auth[:uid]
      )

      CampaignSpreader.create(
        timeline: twitter_profile,
        campaign_id: campaign_spreader["campaign_id"],
        message: campaign_spreader["message"]
      )

      redirect_to campaign_path(campaign_spreader["campaign_id"]), notice: "Pronto! Obrigado por se juntar a este compartilhaço"
    end
  end

  def failure
    redirect_to Campaign.first, alert: "Você não cedeu as permissões necessárias"
  end
end
