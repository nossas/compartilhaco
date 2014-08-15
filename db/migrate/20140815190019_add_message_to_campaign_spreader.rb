class AddMessageToCampaignSpreader < ActiveRecord::Migration
  def change
    add_column :campaign_spreaders, :message, :text
  end
end
