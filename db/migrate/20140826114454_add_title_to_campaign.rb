class AddTitleToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :title, :string, null: false
  end
end
