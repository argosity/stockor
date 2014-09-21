require 'pathname'
require 'yaml'

module Skr

    module Core
        module DB

            class Seed

                @@seeds = []

                class << self

                    def add(&block)
                        @@seeds.push(block)
                    end

                    # Loads the database with seed models
                    # Currently loads {GlAccount}, {PaymentTerm}, and {Location}
                    def execute!
                        seeds_path = Pathname.new(__FILE__).dirname.join('seed')
                        unless Location.default
                            Location.create( code: Core.config.default_location_code, name: "System default",
                              address: Address.new(name:"System default")
                            )
                        end

                        YAML::load( seeds_path.join('chart_of_accounts.yml').read ).each do | acct_data |
                            GlAccount.where(number: acct_data['number'].to_s).any? || GlAccount.create!(acct_data)
                        end

                        YAML::load( seeds_path.join('payment_terms.yml').read ).each do | acct_data |
                            PaymentTerm.where(code: acct_data['code'].to_s).any? || PaymentTerm.create!(acct_data)
                        end

                        @@seeds.each(&:call)
                    end

                end

            end

        end
    end
end
