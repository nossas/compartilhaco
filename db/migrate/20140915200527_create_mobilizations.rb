class CreateMobilizations < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      execute ""\
        "CREATE FOREIGN TABLE mobilizations(id integer) "\
        "SERVER meurio "\
        "OPTIONS (table_name 'mobilizations');"
    else
      create_table :mobilizations
    end
  end

  def down
    if Rails.env.production? || Rails.env.staging?
      execute "DROP FOREIGN TABLE mobilizations;"
    else
      execute "DROP TABLE mobilizations;"
    end
  end
end
