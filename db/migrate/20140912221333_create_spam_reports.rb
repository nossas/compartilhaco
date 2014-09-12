class CreateSpamReports < ActiveRecord::Migration
  def change
    create_table :spam_reports do |t|

      t.timestamps
    end
  end
end
