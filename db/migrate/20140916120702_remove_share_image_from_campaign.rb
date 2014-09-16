class RemoveShareImageFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :share_image, :string, null: false
  end
end
