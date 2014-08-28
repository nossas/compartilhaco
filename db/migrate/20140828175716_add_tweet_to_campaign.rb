class AddTweetToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :tweet, :text, null: false
  end
end
