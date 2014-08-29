class AddTimelinesTargetToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :timelines_target, :integer, null: false
  end
end
