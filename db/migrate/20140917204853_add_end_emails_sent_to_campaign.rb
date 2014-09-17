class AddEndEmailsSentToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :end_emails_sent, :boolean, default: false
  end
end
