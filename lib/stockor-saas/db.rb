require 'active_record/tasks/database_tasks'
require 'apartment/migrator'

module StockorSaas

    module DB
        extend self

        def migrate_all
            Apartment::Tenant.each do | tenant |
                each_ext do | ext |
                    Apartment::Migrator.migrate tenant
                end
            end
        end

        def seed_all
            Apartment::Tenant.each do
                each_ext do | ext |
                   load_seed_file(ext)
                end
            end
        end

        def seed_tenant(tenant)
            Apartment::Tenant.switch(tenant) do
                each_ext do | ext |
                    load_seed_file(ext)
                end
            end
        end

        def load_seed_file(ext)
            seed = ext.root_path.join('db', 'seed.rb')
            load(seed) if seed.exist?
        end

        def each_ext
            Lanes::Extensions.each do |ext|
                Dir.chdir(ext.root_path) do
                    puts("\t" + ext.identifier)
                    yield ext
                end
            end
        end
    end
end
