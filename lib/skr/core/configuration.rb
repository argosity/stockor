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

            # The Accounts Payable (AP) GL account number to use for freshly created Vendors
            config_option :default_gl_ap_account_number, '2200'

            # The Accounts Receivable (AR) GL account number to use for freshly created Customers
            config_option :default_gl_ar_account_number, '1200'
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
