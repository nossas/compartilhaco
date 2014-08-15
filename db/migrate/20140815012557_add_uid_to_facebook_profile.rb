class AddUidToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :uid, :string, null: false
    add_index :facebook_profiles, :uid, unique: true
  end
end
