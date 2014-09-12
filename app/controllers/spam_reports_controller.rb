class SpamReportsController < ApplicationController
  def create
    SpamReport.create(
      campaign_id: params[:campaign_id],
      user_id: current_user.id
    )

    redirect_to campaign_path(id: params[:campaign_id])
  end
end
