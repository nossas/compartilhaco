class CampaignSpreadersController < ApplicationController
  def create
    if params[:campaign_spreader]
      session[:campaign_spreader] = params[:campaign_spreader]
      redirect_to '/auth/facebook', scope: 'publish_actions'
    elsif session[:campaign_spreader]
      auth = request.env['omniauth.auth']
      campaign_spreader = session.delete(:campaign_spreader)

      user = User.create(
        email: campaign_spreader["timeline"]["user"]["email"],
        first_name: auth[:info][:first_name],
        last_name: auth[:info][:last_name],
        ip: request.remote_ip
      )

      facebook_profile = FacebookProfile.create(
        user_id: user.id,
        uid: auth[:uid],
        token: auth[:credentials][:token],
        expires_at: Time.at(auth[:credentials][:expires_at])
      )

      CampaignSpreader.create timeline: facebook_profile

      redirect_to Campaign.first, notice: "Feitooo"
    end
  end
end
