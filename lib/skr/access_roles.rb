require 'lanes/access'
require_relative "model"

module Lanes::Access
    module Roles


        # re-open the exising Support role
        class Support
            grant Skr::Customer,
                  Skr::Sku,
                  Skr::SalesOrder

        end


        class Accounting < Lanes::Access::Role
            grant Skr::Customer,
                  Skr::PaymentTerm,
                  Skr::Sku,
                  Skr::SalesOrder
            lock_writes Skr::Customer, :terms
            lock Skr::Sku, :gl_asset_account
            lock Skr::Customer, :gl_receivables_account
        end


        class Purchasing < Lanes::Access::Role
            read Skr::Customer
            grant Skr::Sku,
                  Skr::SalesOrder
        end

    end

    Role.grant_global_access(Skr::Address)
    Role.grant_global_access(:read, Skr::PaymentTerm)

end
