require 'bundler'
Bundler.require
require_relative 'lib/skr'
require 'lanes/api'
run Lanes::API::Root
