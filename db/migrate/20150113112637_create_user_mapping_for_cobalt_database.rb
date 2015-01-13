class CreateUserMappingForCobaltDatabase < ActiveRecord::Migration
  def up
    if Rails.env.production?
      execute <<-SQL
      CREATE USER MAPPING for #{ENV["DB_USERNAME"]}
      SERVER meurio_accounts
      OPTIONS (
        user      '#{ENV["MEURIO_ACCOUNTS_DBUSER"]}',
        password  '#{ENV["MEURIO_ACCOUNTS_DBPASS"]}'
      );
      SQL
    end
  end

  def down
    if Rails.env.production?
      execute <<-SQL
      DROP USER MAPPING IF EXISTS FOR #{ENV["DB_USERNAME"]}
      SERVER meurio_accounts
      SQL
    end
  end
end
