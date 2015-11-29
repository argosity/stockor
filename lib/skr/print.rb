require 'erb_latex'
require_relative 'print/template'
require_relative 'print/pdf'

module Skr
    module Print
        ROOT = Pathname.new(__FILE__).dirname.join("../../templates/print")
    end
end
