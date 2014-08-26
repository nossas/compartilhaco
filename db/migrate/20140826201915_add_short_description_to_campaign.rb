class AddShortDescriptionToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :short_description, :text, null: false
  end
end
