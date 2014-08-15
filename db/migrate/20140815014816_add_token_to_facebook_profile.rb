class AddTokenToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :token, :string, null: false
  end
end
