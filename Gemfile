source "https://rubygems.org"

# Declare your gem's dependencies in workspace.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'stockor-core', path: '../core'
gem 'stockor-api',  path: '../api'
gem 'coffee-rails'

group :development, :test do
    gem "guard-jasmine", path: '../../guard-jasmine'
    gem 'growl'
    gem 'terminal-notifier-guard'
end
