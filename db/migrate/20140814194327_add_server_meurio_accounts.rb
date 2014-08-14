class AddServerMeurioAccounts < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      raise "MEURIO_ACCOUNTS_DBNAME is missing" if ENV["MEURIO_ACCOUNTS_DBNAME"].nil?
      raise "MEURIO_ACCOUNTS_DBHOST is missing" if ENV["MEURIO_ACCOUNTS_DBHOST"].nil?
      raise "MEURIO_ACCOUNTS_DBUSER is missing" if ENV["MEURIO_ACCOUNTS_DBUSER"].nil?
      raise "MEURIO_ACCOUNTS_DBPASS is missing" if ENV["MEURIO_ACCOUNTS_DBPASS"].nil?
      raise "MEURIO_ACCOUNTS_DBPORT is missing" if ENV["MEURIO_ACCOUNTS_DBPORT"].nil?
      raise "DB_USERNAME is missing" if ENV["DB_USERNAME"].nil?

      execute <<-SQL
      CREATE EXTENSION postgres_fdw;

      CREATE SERVER meurio_accounts
      FOREIGN DATA WRAPPER postgres_fdw
      OPTIONS (
        dbname  '#{ENV["MEURIO_ACCOUNTS_DBNAME"]}',
        host    '#{ENV["MEURIO_ACCOUNTS_DBHOST"]}',
        port    '#{ENV["MEURIO_ACCOUNTS_DBPORT"]}'
      );

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
    if Rails.env.production? || Rails.env.staging?
      execute "DROP EXTENSION postgres_fdw CASCADE;"
    end
  end
end
