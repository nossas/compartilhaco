class RemoveShareDescriptionFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :share_description, :text, null: false
  end
end
