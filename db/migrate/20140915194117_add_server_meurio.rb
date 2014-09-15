class AddServerMeurio < ActiveRecord::Migration
  def up
    if Rails.env.production? || Rails.env.staging?
      raise "MEURIO_DBNAME is missing" if ENV["MEURIO_DBNAME"].nil?
      raise "MEURIO_DBHOST is missing" if ENV["MEURIO_DBHOST"].nil?
      raise "MEURIO_DBUSER is missing" if ENV["MEURIO_DBUSER"].nil?
      raise "MEURIO_DBPASS is missing" if ENV["MEURIO_DBPASS"].nil?
      raise "MEURIO_DBPORT is missing" if ENV["MEURIO_DBPORT"].nil?
      raise "DB_USERNAME is missing" if ENV["DB_USERNAME"].nil?

      execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS postgres_fdw;

      CREATE SERVER meurio
      FOREIGN DATA WRAPPER postgres_fdw
      OPTIONS (
        dbname  '#{ENV["MEURIO_DBNAME"]}',
        host    '#{ENV["MEURIO_DBHOST"]}',
        port    '#{ENV["MEURIO_DBPORT"]}'
      );

      CREATE USER MAPPING for #{ENV["DB_USERNAME"]}
      SERVER meurio
      OPTIONS (
        user      '#{ENV["MEURIO_DBUSER"]}',
        password  '#{ENV["MEURIO_DBPASS"]}'
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
