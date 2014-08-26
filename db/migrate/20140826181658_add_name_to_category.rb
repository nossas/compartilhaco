class AddNameToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :name, :string, null: false
  end
end
