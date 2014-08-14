class CreateFacebookProfiles < ActiveRecord::Migration
  def change
    create_table :facebook_profiles do |t|

      t.timestamps
    end
  end
end
