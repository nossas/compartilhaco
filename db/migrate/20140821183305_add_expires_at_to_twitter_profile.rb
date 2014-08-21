class AddExpiresAtToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :expires_at, :datetime, null: false
  end
end
