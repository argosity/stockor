require 'minitest/autorun'
require 'skr/core'

require 'active_record'
require 'active_record/fixtures'
require_relative "../../core"

ENV["RAILS_ENV"] = "test"
RAILS_ENV = "test"
I18n.enforce_available_locales = true
Skr::Core::DB.establish_connection('test')
Skr::Core.logger=Logger.new( File.open('log/test.log', File::WRONLY | File::APPEND | File::CREAT ))
ActiveRecord::Base.logger = Skr::Core.logger
ActiveSupport::Dependencies.mechanism = :require

require_relative 'assertions'
require_relative 'fixtures'
require_relative 'test_case'
