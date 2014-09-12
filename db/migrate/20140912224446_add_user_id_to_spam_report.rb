class AddUserIdToSpamReport < ActiveRecord::Migration
  def change
    add_column :spam_reports, :user_id, :integer, foreign_key: false, null: false
  end
end
