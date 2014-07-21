require 'skr/core/db/migrations'

module Stockor

    module Migrations

        class InstallGenerator < Rails::Generators::Base
            include Rails::Generators::Migration

            source_root Skr::Core::DB::Migrations.paths.first

            Skr::Core::DB::Migrations.paths.slice(1..-1).each do | source_path |
                source_paths << source_path
            end

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
                Skr::Core::DB::Migrations.paths.each do | source_path |

                    Pathname.glob( source_path.join('*') ).each do | migration |
                        from = File.basename( migration )
                        dest = from.gsub(/^\d+_(.*).rb$/,'\\1.rb')
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
end
