class AddTimelineTypeToCampaignSpreader < ActiveRecord::Migration
  def change
    add_column :campaign_spreaders, :timeline_type, :string, null: false
  end
end
