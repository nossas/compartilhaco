class AddUidToCampaignSpreader < ActiveRecord::Migration
  def change
    add_column :campaign_spreaders, :uid, :string
  end
end
