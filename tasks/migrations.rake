require 'active_record'
require 'active_support/core_ext/string/strip'
require 'fileutils'
require 'skr/core'
## quite a bit of this is cribbed from Sinatra ActiveRecord

load 'active_record/railties/databases.rake'
require 'rake'


namespace :db do

    task :environment do
        ActiveRecord::Tasks::DatabaseTasks.seed_loader = Skr::Core::DB
        env = ENV['RAILS_ENV'] || 'development'

        Skr::Core::DB.config_file ||= 'config/database.yml'
        ENV['SCHEMA'] ||= 'db/schema.sql'
        ENV['DB_STRUCTURE'] ||= 'db/schema.sql'
        ActiveRecord::Base.schema_format = :sql
        Skr::Core::DB.establish_connection( env )
        ActiveRecord::Tasks::DatabaseTasks.database_configuration = ActiveRecord::Base.configurations
        ActiveRecord::Tasks::DatabaseTasks.env = 'test'
        ActiveRecord::Tasks::DatabaseTasks.migrations_paths = 'db/migrate'
        ActiveRecord::Tasks::DatabaseTasks.current_config( :config => ActiveRecord::Base.configurations[ env ] )
    end

    desc "create an ActiveRecord migration"
    task :create_migration,[ :name ] do | t, args |
        Skr::Core::DB.create_migration( "create_skr_" + args[:name] )
    end


end
