$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "skr/workspace/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
    spec.name          = "stockor-workspace"
    spec.version       = Skr::Workspace::VERSION
    spec.authors       = ["Nathan Stitt"]
    spec.email         = ["nathan@stitt.org"]
    spec.summary       = %q{Stockor App contains the web application for Stockor}
    spec.description   = %q{Stockor App contains the web application for Stockor; it uses the Stockor API to manage the application}
    spec.homepage      = "http://stockor.org/"
    spec.license       = "GPL-3.0"

    spec.files         = `git ls-files`.split($/)
    spec.test_files = Dir["test/**/*"]

    spec.required_ruby_version = '>= 2.0'
    spec.add_dependency "stockor-core", "0.2"
    spec.add_dependency "stockor-api", "0.2"

    spec.add_dependency "rails", "~> 4.1.0"
    spec.add_dependency "sprockets-rails", "~> 2.1"
    spec.add_dependency "sass-rails", "~> 4.0"
    spec.add_dependency "coffee-script"


    spec.add_development_dependency "bundler", "~> 1.5"
    spec.add_development_dependency "jasmine"

end
