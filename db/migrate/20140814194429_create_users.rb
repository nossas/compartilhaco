class CreateUsers < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      execute ""\
        "CREATE FOREIGN TABLE users(id integer) "\
        "SERVER meurio_accounts "\
        "OPTIONS (table_name 'users');"
    else
      create_table :users
    end
  end

  def down
    if Rails.env.production? || Rails.env.staging?
      execute "DROP FOREIGN TABLE users;"
    else
      execute "DROP TABLE users;"
    end
  end
end
