class AddTitleToMobilization < ActiveRecord::Migration
  def change
    add_column :mobilizations, :title, :string
  end
end
