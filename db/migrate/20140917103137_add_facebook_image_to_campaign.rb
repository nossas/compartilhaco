class AddFacebookImageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :facebook_image, :string
  end
end
