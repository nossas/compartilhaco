class AddUidToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :uid, :string, null: false
    add_index :twitter_profiles, :uid, unique: true
  end
end
