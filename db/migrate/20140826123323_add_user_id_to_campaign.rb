class AddUserIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :user_id, :integer, foreign_key: false, null: false
  end
end
