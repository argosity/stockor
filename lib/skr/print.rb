require 'erb_latex'
# need ordinalize
require 'active_support/core_ext/integer/inflections'
require_relative 'print/template'
require_relative 'print/form'
require_relative 'print/context'

module Skr
    module Print
        ROOT = Pathname.new(__FILE__).dirname.join("../../templates/print")
    end
end
