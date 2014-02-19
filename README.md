# Stockor Core

Stockor is a ERP system that contains all the tools you'll need to run a small to medium sized business on the internet.

The core gem records business activity for a company to include:

 * Invoicing
 * Sales Orders
 * Purchase Orders
 * SKUs
 * Multi-Location Inventory management
 * Customers
 * Vendors
 * General Ledger chart of accounts

## Read more at [stockor.org](http://stockor.org/)

## Installation

Add this line to your application's Gemfile:

    gem 'skr-core'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skr-core

## Usage

    require 'skr/core'

    entry = GlManualEntry.create({ notes: 'Pay Rent' })
    transaction = GlTransaction.new({ source: entry, :amount=> 1400.00 })
    transaction.credit.account = GlAccount.find_by_number( '6600' )
    transaction.debit.account  = GlAccount.find_by_number( '1000' )
    transaction.save

## Contributing

The standard instructions are always good:

 1. Fork it ( http://github.com/argosity/skr-core/fork )
 2. Create your feature branch (`git checkout -b my-new-feature`)
 3. Commit your changes (`git commit -am 'Add some feature'`)
 4. Push to the branch (`git push origin my-new-feature`)
 5. Create new Pull Request


Really though, if you've got a feature you've added we're glad to work with you.  Get us the code however you're able to and we can figure it out.
