require "bundler/gem_tasks"
require 'rake/testtask'
require 'yard'
require_relative 'yard_ext/all'
require 'guard'

Dir.glob('tasks/*.rake').each { |r| load r}


Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = "test/*_test.rb"
end


YARD::Rake::YardocTask.new do |t|
    t.files   = ['lib/skr/concerns/*.rb','lib/**/*.rb','db/schema.rb']
    t.options = ["--title='Stockor Core Documentation'",
                 "--markup=markdown",
                 "--template-path=yard_ext/templates",
                 "--readme=README.md"]
end


desc "Open an irb session preloaded with skr-core"
task :console do
    require 'irb'
    require 'irb/completion'
    require 'pp'
    require 'skr/core'
    include Skr
    Skr::Core::DB.establish_connection
    ActiveRecord::Base.logger = Logger.new STDOUT
    ARGV.clear
    IRB.start
end


task :doc => 'db:environment' do
    #env = ENV['RAILS_ENV'] || 'development'
    ENV['SCHEMA']       = 'db/schema.rb'
    ENV['DB_STRUCTURE'] = 'db/schema.rb'
    Rake::Task["db:schema:dump"].invoke
    Rake::Task["yard"].invoke
end


task :guard => [ 'db:migrate', 'db:test:clone_structure' ] do
    sh "bundle exec guard"
end
