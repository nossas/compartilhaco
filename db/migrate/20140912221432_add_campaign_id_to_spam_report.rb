class AddCampaignIdToSpamReport < ActiveRecord::Migration
  def change
    add_column :spam_reports, :campaign_id, :integer, null: false
  end
end
