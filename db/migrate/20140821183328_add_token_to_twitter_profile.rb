class AddTokenToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :token, :string, null: false
  end
end
