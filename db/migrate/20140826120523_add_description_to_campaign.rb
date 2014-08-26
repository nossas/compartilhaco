class AddDescriptionToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :description, :text, null: false
  end
end
