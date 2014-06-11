require 'pathname'
require 'yaml'
module Skr
    module Core
        module DB

            extend self

            # Loads the database with seed models
            # Currently only loads {GlAccount} and {PaymentTerm}
            def seed!
                YAML::load( seeds_path.join('chart_of_accounts.yml').read ).each do | acct_data |
                    GlAccount.where(number: acct_data['number'].to_s).any? || GlAccount.create!(acct_data)
                end
                YAML::load( seeds_path.join('payment_terms.yml').read ).each do | acct_data |
                    PaymentTerm.where(code: acct_data['code'].to_s).any? || PaymentTerm.create!(acct_data)
                end

            end

            def seeds_path
                Pathname.new(__FILE__).dirname.join('seed')
            end
        end
    end
end
