class AddShareDescriptionToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :share_description, :text, null: false
  end
end
