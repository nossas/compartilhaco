class AddMetaImageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :meta_image, :string
  end
end
