# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'skr/core/version'

Gem::Specification.new do |spec|

  spec.name          = "stockor-core"
  spec.version       = Skr::Core::VERSION
  spec.authors       = ["Nathan Stitt"]
  spec.email         = ["nathan@argosity.com"]

  spec.summary       = %q{Stockor Core contains the models for the Stockor ERP system}
  spec.description   = %q{Stockor Core contains the ActiveRecord models and business logic for the Stockor ERP system}

  spec.homepage      = "http://stockor.org/"
  spec.license       = "GPL-3.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'
  spec.add_dependency 'activerecord', '~> 4.1'
  spec.add_dependency 'pg', '~> 0.17'
  spec.add_dependency 'aasm', '~>3.1'
  spec.add_dependency "require_all",  '~> 1.3'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "growl"
  spec.add_development_dependency "pry-plus"
  spec.add_development_dependency "guard-minitest"


end
