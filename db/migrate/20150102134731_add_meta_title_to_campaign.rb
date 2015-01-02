class AddMetaTitleToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :meta_title, :string
  end
end
