class CreateOrganizations < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      execute ""\
        "CREATE FOREIGN TABLE organizations(id integer) "\
        "SERVER meurio_accounts "\
        "OPTIONS (table_name 'organizations');"
    else
      create_table :organizations
    end
  end

  def down
    if Rails.env.production? || Rails.env.staging?
      execute "DROP FOREIGN TABLE organizations;"
    else
      execute "DROP TABLE organizations;"
    end
  end
end
