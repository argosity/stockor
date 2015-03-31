require 'lanes/access'
require_relative "model"

module Lanes::Access
    module Roles


        # re-open the exising Support role
        class Support
            grant Skr::Customer
        end


        class Accounting < Lanes::Access::Role
            grant Skr::Customer, Skr::PaymentTerm

            lock_writes Skr::Customer, :terms_id
        end


        class Purchasing < Lanes::Access::Role
            self.read  << Skr::Customer
        end

    end

    Role.grant_global_access(:read, Skr::PaymentTerm)

end
