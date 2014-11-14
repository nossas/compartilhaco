class ReAddPasswordToUser < ActiveRecord::Migration
  def change
    if Rails.env.development? || Rails.env.test?
      add_column :users, :password, :string
    end
  end
end
