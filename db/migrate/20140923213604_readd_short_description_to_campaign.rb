class ReaddShortDescriptionToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :short_description, :text
  end
end
