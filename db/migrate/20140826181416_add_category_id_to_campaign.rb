class AddCategoryIdToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :category_id, :integer, null: false
  end
end
