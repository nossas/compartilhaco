class RemoveShareTitleFromCampaign < ActiveRecord::Migration
  def change
    remove_column :campaigns, :share_title, :string, null: false
  end
end
