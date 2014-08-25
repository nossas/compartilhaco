class AddSecretToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :secret, :string, null: false
  end
end
