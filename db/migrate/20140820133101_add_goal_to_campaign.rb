class AddGoalToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :goal, :integer, null: false
  end
end
