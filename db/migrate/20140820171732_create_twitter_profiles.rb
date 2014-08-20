class CreateTwitterProfiles < ActiveRecord::Migration
  def change
    create_table :twitter_profiles do |t|

      t.timestamps
    end
  end
end
