class AddUserIdToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :user_id, :integer, foreign_key: false, null: false
    add_index :twitter_profiles, :user_id, unique: true
  end
end
