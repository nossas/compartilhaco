class AddSharedAtToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :shared_at, :datetime
  end
end
