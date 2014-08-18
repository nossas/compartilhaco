class AddFacebookFriendsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_friends_count, :integer
  end
end
