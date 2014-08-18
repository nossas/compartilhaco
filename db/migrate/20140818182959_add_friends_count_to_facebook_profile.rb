class AddFriendsCountToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :friends_count, :integer
  end
end
