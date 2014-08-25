class AddFollowersCountToTwitterProfile < ActiveRecord::Migration
  def change
    add_column :twitter_profiles, :followers_count, :integer
  end
end
