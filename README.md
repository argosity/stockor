# Stockor

## A business management system for freelancers, contractors and small business owners.

### Features

 * Per Project/Customer Time Tracking
 * Sales Orders and Invoicing
 * Customers and Vendors
 * Completely web-based, user interface is React / Bootstrap
 * Mobile friendly, screens are responsive
 * Chart of Accounts and double-entry General Ledger.
 * Real-time updates for multi-user access
 * Released under the open-source AGPL3 license


### Demo
A demo that shows off portions of the interface is available at [demo.stockor.com]("http://demo.stockor.com/).  The demo is set to randomly create updates for the `STOCKOR` customer and vendor.  If you load one of those records you should be able to observe the updates occur.

### Tech stack

Stockor's server-side component is written in Ruby on top of the Sinatra derived [Lanes framework](https://github.com/argosity/lanes).  It borrows several familiar libraries from Rails such as ActiveRecord and Sprockets.

The web interface is React and Bootstrap.  There's a bit of light customization on the class creation to seamlessly support a custom data layer that's built off of [ampersand state](https://github.com/AmpersandJS/ampersand-state).

### Contributing and bug reports

Are welcome ;-)  Typical github flow - file a issue or pull request.  If you'd like to chat about anything Stockor related feel free to drop us a line at contact@argosity.com
