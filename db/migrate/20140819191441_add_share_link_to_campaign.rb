class AddShareLinkToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :share_link, :string, null: false
  end
end
