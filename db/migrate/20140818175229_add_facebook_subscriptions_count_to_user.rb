class AddFacebookSubscriptionsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_subscriptions_count, :integer
  end
end
