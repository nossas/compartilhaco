class AddOrganizationIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :organization_id, :integer, foreign_key: false, null: false
  end
end
