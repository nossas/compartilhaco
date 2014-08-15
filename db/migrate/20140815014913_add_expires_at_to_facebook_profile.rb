class AddExpiresAtToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :expires_at, :datetime, null: false
  end
end
