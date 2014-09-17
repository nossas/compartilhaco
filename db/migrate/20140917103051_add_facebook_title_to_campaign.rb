class AddFacebookTitleToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :facebook_title, :string
  end
end
