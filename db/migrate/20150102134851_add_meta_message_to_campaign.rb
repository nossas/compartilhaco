class AddMetaMessageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :meta_message, :text
  end
end
