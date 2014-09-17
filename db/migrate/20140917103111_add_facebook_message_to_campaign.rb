class AddFacebookMessageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :facebook_message, :text
  end
end
