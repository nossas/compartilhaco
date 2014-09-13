class AddUserIdToSpamReport < ActiveRecord::Migration
  def change
    add_column :spam_reports, :user_id, :integer, foreign_key: false, null: false
    add_index :spam_reports, [:campaign_id, :user_id], unique: true
  end
end
