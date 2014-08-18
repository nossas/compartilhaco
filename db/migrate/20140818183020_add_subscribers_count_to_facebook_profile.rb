class AddSubscribersCountToFacebookProfile < ActiveRecord::Migration
  def change
    add_column :facebook_profiles, :subscribers_count, :integer
  end
end
