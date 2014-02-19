module Skr

    module Migrations

        class InstallGenerator < Rails::Generators::Base
            include Rails::Generators::Migration
            @@migrations_dir = File.expand_path( File.join(File.dirname(__FILE__), '../../../../db/migrate'))
            #puts @@migrations_dir
            source_root @@migrations_dir

            desc "Install Stockor migrations"
            def self.next_migration_number(path)
                unless @prev_migration_nr
                    @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
                else
                    @prev_migration_nr += 1
                end
                @prev_migration_nr.to_s
            end

            def copy_migrations
                Dir.glob( @@migrations_dir + '/*' ).sort.each do | migration |
                    from = File.basename( migration )
                    dest = from.gsub(/^\d+_(.*).rb$/,'\\1')
                    if self.class.migration_exists?("db/migrate", "#{dest}")
                        say_status("skipped", "Migration #{dest} already exists")
                    else
                        migration_template( from, "db/migrate/#{dest}" )
                    end
                end
            end

        end
    end
end
