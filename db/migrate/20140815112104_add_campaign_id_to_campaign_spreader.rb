class AddCampaignIdToCampaignSpreader < ActiveRecord::Migration
  def change
    add_column :campaign_spreaders, :campaign_id, :integer, null: false
  end
end
