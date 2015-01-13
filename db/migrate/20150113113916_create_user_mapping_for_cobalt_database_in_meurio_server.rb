class CreateUserMappingForCobaltDatabaseInMeurioServer < ActiveRecord::Migration
  def up
    if Rails.env.production?
      execute <<-SQL
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
    if Rails.env.production?
      execute <<-SQL
      DROP USER MAPPING IF EXISTS FOR #{ENV["DB_USERNAME"]}
      SERVER meurio
      SQL
    end
  end
end
