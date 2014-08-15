class AddTimelineIdToCampaignSpreader < ActiveRecord::Migration
  def change
    add_column :campaign_spreaders, :timeline_id, :integer, null: false, foreign_key: false
  end
end
