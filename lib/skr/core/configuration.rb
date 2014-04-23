require_relative "../concerns/attr_accessor_with_default"

module Skr
    module Core

        class Configuration
            include Skr::Concerns::AttrAccessorWithDefault
            # Since changing a config value inadvertently
            # can have pretty drastic consequences that might not be
            # discovered immediately, we log each time a value is changed
            def self.config_option( name, default )
                define_method( "#{name}=" ) do | value |
                    old_value = self.send( name )
                    Skr::Core.logger.info "Skr::Core.conf.#{name} changed from #{old_value} to #{value}"
                    instance_variable_set( "@#{name}", value )
                end
                attr_reader_with_default( name, default )
            end


            # Since the Configuration class is essentially a singleton,
            # we don't care about AttrReaderWithDefault sharing values between instances
            # Therefore all the values are given directly and not enclosed in Procs/lambdas.

            # Database tables will have this prefix applied to them
            config_option :table_prefix, 'skr_'

            # The GL branch code to use for default newly created locations
            config_option :default_branch_code, '01'

            # The string value of the UserModel.  Will be set on model's updated_by and created_by
            config_option :user_model, 'UserProxy'

            # Transactions that do not specify a location will use the one that's identified by this code
            config_option :default_location_code, 'DEFAULT'

            # Do freshly created SKUs default to being backorderable?
            config_option :skus_backorder_default, true

            # The code for a Sku that represents tax
            config_option :tax_sku_code, 'TAX'

            # Code for a Sku that represents shipping charges
            config_option :ship_sku_code, 'SHIP'

            config_option :default_gl_accounts, {
                # The Accounts Receivable (AR) GL account number to use for freshly created Customers
                ar: '1200',
                # The Accounts Payable (AP) GL account number to use for freshly created Vendors
                ap: '2200',
                # The Freight GL account number to use for freshly created Vendors
                freight: '6420',
                # The Asset GL account number to use for freshly created SKUs
                asset: '1100',
                # Clearing account for inventory that's been
                inventory_receipts_clearing: '2600',
                # Holding account for funds that are awaiting deposit
                deposit_holding: '1010'
            }
        end

        class << self
            @@config = Configuration.new
            def config
                @@config
            end

            def configure
                yield(@config)
            end
        end

    end
end
