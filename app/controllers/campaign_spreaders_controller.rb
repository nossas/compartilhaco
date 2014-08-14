class CampaignSpreadersController < ApplicationController
  def create
    user = User.create email: params[:campaign_spreader][:timeline][:user][:email]
    FacebookProfile.create user_id: user.id
    redirect_to Campaign.first, notice: "Feitooo"
  end
end
