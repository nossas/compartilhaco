class AddDeliveredExpiringAlertToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :delivered_expiring_alert, :boolean, default: false
  end
end
