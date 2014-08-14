class CreateCampaignSpreaders < ActiveRecord::Migration
  def change
    create_table :campaign_spreaders do |t|

      t.timestamps
    end
  end
end
