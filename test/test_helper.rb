require 'minitest/unit'
require 'minitest/autorun'
require 'turn'
require 'active_record'
require 'active_record/fixtures'

require_relative '../lib/skr/core'
require_relative 'helpers/assertions'
require_relative 'helpers/fixtures'
require_relative 'helpers/test_case'


ENV["RAILS_ENV"] = "test"
RAILS_ENV = "test"


Skr::Core::DB.establish_connection( 'test' )
Skr::Core.logger=Logger.new( File.open('log/test.log', File::WRONLY | File::APPEND | File::CREAT ) )
ActiveRecord::Base.logger = Skr::Core.logger

Turn.config do |c|
    # use one of output formats:
    # :outline  - turn's original case/test outline mode [default]
    # :progress - indicates progress with progress bar
    # :dotted   - test/unit's traditional dot-progress mode
    # :pretty   - new pretty reporter
    # :marshal  - dump output as YAML (normal run mode only)
    # :cue      - interactive testing
    c.format  = :pretty
    # turn on invoke/execute tracing, enable full backtrace
    c.trace   = 26
    # use humanized test names (works only with :outline format)
    c.natural = true
end
