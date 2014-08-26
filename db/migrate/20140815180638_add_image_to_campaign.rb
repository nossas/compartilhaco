class AddImageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :image, :string, null: false
  end
end
