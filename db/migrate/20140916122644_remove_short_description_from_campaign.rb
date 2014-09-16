class RemoveShortDescriptionFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :short_description, :text, null: false
  end
end
