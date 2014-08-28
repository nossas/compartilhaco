class AddShareImageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :share_image, :string, null: false
  end
end
