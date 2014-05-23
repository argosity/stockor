# Stockor Workspace

The Stockor Workspace is a Rails engine that serves up the web user interface for the Stockor ERP system.

It's very much a work in progress and is currently little more than an exploratory spike.

It's built using Backbone.js and the Bootstrap user interface library and is intended to be fully responsive.


## Installation

Add this line to your Rails application's Gemfile:

    gem 'stockor-workspace'

And then execute:

    $ bundle

Add it to Rail's routes.rb:

    mount Skr::Workspace::Root => '/stockor'

Then access it at `/stockor`

## Contributing

The standard instructions are always good:

1. Fork it ( http://github.com/<my-github-username>/stockor-workspace/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Really though, if you've got a feature you've added we're glad to work with you.  Get us the code however you're able to and we can figure it out.
