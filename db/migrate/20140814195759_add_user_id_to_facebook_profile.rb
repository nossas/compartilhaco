class AddUserIdToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :user_id, :integer, null: false, foreign_key: false
    add_index :facebook_profiles, :user_id, unique: true
  end
end
