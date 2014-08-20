class AddEndsAtToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :ends_at, :datetime, null: false
  end
end
