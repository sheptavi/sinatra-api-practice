require 'rake'
require 'sequel'

namespace :db do
  # Подключение к базе данных для задач
  def connect_db
    Sequel.connect(
      adapter: :postgres,
      database: 'sinatra_seq_dev',
      host: 'localhost',
      password: 'password',
      user: 'sinatra_admin'
    )
  end

  desc "Prints current schema version"
  task :version do
    db = connect_db
    version = if db.tables.include?(:schema_info)
                db[:schema_info].first[:version]
              end || 0
    puts "Schema Version: #{version}"
  end

  desc 'Run migrations up to specified version or to latest.'
  task :migrate, [:version] do |_, args|
    db = connect_db
    Sequel.extension :migration
    migrations_directory = 'db/migrations'
    version = args[:version]

    if version.nil?
      Sequel::Migrator.run(db, migrations_directory)
      puts 'Migrated to latest'
    else
      Sequel::Migrator.run(db, migrations_directory, target: version.to_i)
      puts "Migrated to version #{version}"
    end
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback, [:target] do |_, args|
    args.with_defaults(target: 0)
    db = connect_db
    Sequel.extension :migration
    Sequel::Migrator.run(db, 'db/migrations', target: args[:target].to_i)
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset do
    db = connect_db
    Sequel.extension :migration
    Sequel::Migrator.run(db, 'db/migrations', target: 0)
    Sequel::Migrator.run(db, 'db/migrations')
    Rake::Task['db:version'].execute
  end

  desc "Load seeds into the database"
  task :seed do
    require 'sequel/extensions/seed'
    Sequel.extension :seed
    db = connect_db
    
    # Cбрасываем память сидов и сами таблицы перед запуском
    db[:jobs].truncate(cascade: true, restart: true) rescue nil
    db[:companies].truncate(cascade: true, restart: true) rescue nil
    db[:schema_seeds].delete rescue nil
    
    # Применяем сиды
    Sequel::Seeder.apply(db, './seeds')
    puts "Seeds loaded successfully"
  end
end