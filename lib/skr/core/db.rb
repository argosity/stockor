require_relative 'db/seed'

module Skr
    module Core
        module DB
            extend self

            attr_accessor(:config_file)

            def establish_connection( env = ENV['RAILS_ENV'] || 'development')
                file = config_file || 'config/database.yml'
                config = YAML::load( IO.read( file ) )
                ::ActiveRecord::Base.configurations = config
                self.connect( ::ActiveRecord::Base.configurations[ env ] )
            end

            def connect( configuration )
                ::ActiveRecord::Base.establish_connection( configuration )
            end

            def migration_exists?( file_name ) #:nodoc:
                Dir.glob("#{migrations_dir}/[0-9]*_*.rb").grep(/\d+_#{file_name}.rb$/).first
            end

            def configure_rake_environment
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

            def create_migration( migration_name )
                STDERR.puts "Migration #{migration_name} already exists!" and return false if migration_exists?( migration_name )
                migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S")
                migration_file = File.join(migrations_dir, "#{migration_number}_#{migration_name}.rb")
                migration_class = migration_name.split("_").map(&:capitalize).join
                File.open(migration_file, 'w') do |file|
                    file.write <<-MIGRATION.strip_heredoc
            class #{migration_class} < ActiveRecord::Migration
                def change
                end
            end
            MIGRATION
                end
            end

            def migrate(version = nil)
                silence_activerecord do
                    migration_version = version ? version.to_i : version
                    ::ActiveRecord::Migrator.migrate( migrations_dir, migration_version )
                end
            end

            def rollback(step = nil)
                silence_activerecord do
                    migration_step = step ? step.to_i : 1
                    ::ActiveRecord::Migrator.rollback(migrations_dir, migration_step)
                end
            end

            def self.load_seed

                unless Location.any?
                    Location.create( code: "DEFAULT", name: "Stockor default location" )
                end

            end

            private

            def migrations_dir
                ::ActiveRecord::Migrator.migrations_paths.first
            end

            def silence_activerecord(&block)
                old_logger = ::ActiveRecord::Base.logger
                ::ActiveRecord::Base.logger = nil
                yield if block_given?
                ::ActiveRecord::Base.logger = old_logger
            end
        end
    end
end
