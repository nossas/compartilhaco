class AddNewCampaignSpreaderMailToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :new_campaign_spreader_mail, :text, null: false
  end
end
