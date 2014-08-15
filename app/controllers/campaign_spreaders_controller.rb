class CampaignSpreadersController < ApplicationController
  def create
    user = User.create email: params[:campaign_spreader][:timeline][:user][:email]
    facebook_profile = FacebookProfile.create user_id: user.id
    CampaignSpreader.create timeline: facebook_profile
    redirect_to Campaign.first, notice: "Feitooo"
  end
end
