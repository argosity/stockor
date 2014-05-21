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

Usage
------------------------------

##### Creating a GL posting

       require 'skr/core'
       customer = Customer.find_by_code "MONEYBAGS"
       GlTransaction.record( source: invoice, description: "Invoice Example" ) do | transaction |
         transaction.location = Location.default # <- could also specify in record's options
         Sku.where( code: ['HAT','STRING'] ).each do | sku |
           transaction.add_posting( amount: sku.default_price,
                                    debit:  sku.gl_asset_account,
                                    credit: customer.gl_receivables_account )
         end
       end

##### Create a SalesOrder

        customer = Customer.find_by_code "VIP1"
        so = SalesOrder.new( customer: customer )
        Sku.where( code: ['HAT','STRING'] ).each do | sku |
            so.lines.build(
              sku_loc: sku.sku_locs.default
            )
        end
        so.save

##### Create a PurchaseOrder

        vendor = Vendor.find_by_code "BIGCO"
        po = PurchaseOrder.new( vendor: vendor )
        Sku.where( code: ['HAT','STRING'] ).each do | sku |
            po.lines.build(
              sku_vendor: sku.sku_vendors.for_vendor( vendor )
            )
        end
        po.save

#### Create an Invoice

        invoice = Invoice.new( customer: Customer.find_by_code("ACME")
        invoice.lines.build({ sku: Sku.find_by_code('LABOR'), qty: 1, price: 8.27 })
        invoice.save


## Contributing

The standard instructions are always good:

 1. Fork it ( http://github.com/argosity/skr-core/fork )
 2. Create your feature branch (`git checkout -b my-new-feature`)
 3. Commit your changes (`git commit -am 'Add some feature'`)
 4. Push to the branch (`git push origin my-new-feature`)
 5. Create new Pull Request


Really though, if you've got a feature you've added we're glad to work with you.  Get us the code however you're able to and we can figure it out.
