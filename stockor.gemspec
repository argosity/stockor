# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skr/version'

Gem::Specification.new do |spec|

  spec.name          = "stockor"
  spec.version       = Skr::VERSION
  spec.authors       = ["Nathan Stitt"]
  spec.email         = ["nathan@argosity.com"]

  spec.summary       = %q{Stockor is a complete ERP system}
  spec.description   = %q{Stockor is a complete ERP system that includes billing, inventory, and customer management}

  spec.homepage      = "http://stockor.org/"
  spec.license       = "AGPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1'

  spec.add_dependency 'aasm', '~> 4.11'
  spec.add_dependency 'erb_latex', '1.0'
  spec.add_dependency 'liquid', '~> 4.0'
  spec.add_dependency 'lanes', '~> 0.6'
  spec.add_dependency 'numbers_in_words', '~> 0.4.0'
  spec.add_dependency 'ruby-freshbooks', '~> 0.4'
  spec.add_dependency 'activemerchant', '~> 1.62'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "growl"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "guard-minitest"

end
