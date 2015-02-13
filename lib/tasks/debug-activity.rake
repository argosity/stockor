namespace :demo do
  task :activity do

    require 'faker'
    require 'lanes/api/pub_sub'

    Lanes::DB.establish_connection
    Lanes::API::PubSub.initialize

    attributes = {
      Skr::Address  => [:name,:email,:phone,:line1,:line2,:city,:state,:postal_code],
      Skr::Vendor   => [:name,:notes],
      Skr::Customer => [:name,:notes]
    }

    attribute_values={
      name:        ->{ Faker::Name.name                 },
      notes:       ->{ Faker::Company.catch_phrase      },
      email:       ->{ Faker::Internet.email            },
      phone:       ->{ Faker::PhoneNumber.phone_number  },
      line1:       ->{ Faker::Address.street_address    },
      line2:       ->{ Faker::Address.secondary_address },
      city:        ->{ Faker::Address.city              },
      state:       ->{ Faker::Address.state_abbr        },
      postal_code: ->{ Faker::Address.zip_code          }
    }
    module Lanes::API::Updates
      def self.user_info_for_change(model)
        { id: rand(4)+1, name: Faker::Name.name, email: Faker::Internet.email }
      end
    end

    loop do

      [ Skr::Customer ].each do | klass |
        Thread.current[:demo_user_info] = {
          name:  Faker::Name.name, email: Faker::Internet.email
        }

        record = klass.order(:code).first
        update = case rand(3)
                 when 0 then record
                 when 1 then record.billing_address
                 when 2 then record.shipping_address
                 end

        attribute = attributes[update.class].sample
        value     = attribute_values[attribute].call

        printf("%15s %15s(%3s) %13s => %-20s\n", klass, update.class, update.id, attribute, value )

        update.update_attribute( attribute, value )
      end
      sleep 10

    end
  end
end
