require 'pathname'
require 'yaml'
require_relative '../lib/skr'


module Skr
    user = Lanes::User.where(login: 'admin').first
    if user.nil?
        user = Lanes::User.create!(name: "Admin", email: "admin@test.com",
                                   password: 'password', password_confirmation: 'password',
                                   login: 'admin', role_names: ['administrator'])

    end
    Lanes::User.scoped_to(user) do
        seeds_path = Pathname.new(__FILE__).dirname.join('seed')

        unless Location.default
            Location.create( code: Skr.config.default_location_code, name: "System default",
              address: Address.new(name:"System default")
            )
        end

        YAML::load( seeds_path.join('chart_of_accounts.yml').read ).each do | acct_data |
            GlAccount.where(number: acct_data['number'].to_s).any? || GlAccount.create!(acct_data)
        end

        YAML::load( seeds_path.join('payment_terms.yml').read ).each do | acct_data |
            PaymentTerm.where(code: acct_data['code'].to_s).any? || PaymentTerm.create!(acct_data)
        end
    end

end
