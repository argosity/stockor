require_relative 'lib/stockor-saas'
require 'lanes/rake_tasks'

desc 'start background worker'
task :work => :env do
    ENV['TERM_CHILD']='1'
    ENV['QUEUES']='*'
    Rake::Task["resque:work"].invoke
end

namespace :skrdb do

    desc 'migrate'
    task :migrate => :env do
        StockorSaas::DB.migrate_all
    end

    desc 'seed'
    task :seed => :env do
        StockorSaas::DB.seed_all
    end

end

namespace :tenant do

    desc 'Add a tenant'
    task :add, [:domain, :name] => :env do | t, args |
        tenant = StockorSaas::Tenant.create(domain: args[:domain], name: args[:name])
        if tenant.errors.any?
            STDERR.puts tenant.errors.full_messages
        end
    end

end
