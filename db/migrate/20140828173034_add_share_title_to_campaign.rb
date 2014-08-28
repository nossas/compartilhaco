class AddShareTitleToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :share_title, :string, null: false
  end
end
