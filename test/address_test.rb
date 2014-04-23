require_relative 'test_helper'

class AddressTest < Skr::TestCase


    def test_creation
        addr=Address.new( name:" a test", email:"test@test.com" )
        assert_saves addr
    end

    def test_email_with_name
        addr=Address.new( email: 'john@mcauthor.com', name: 'John D. McAuthor' )
        assert_equal "John D. McAuthor <john@mcauthor.com>", addr.email_with_name
    end

    def test_filling_from_zip
        addr = Address.new( postal_code: '65109' )
        addr.fill_missing_from_zip
        assert_equal 'Jefferson City', addr.city
        assert_equal 'MO', addr.state
    end

    def test_blankness
        addr = Address.blank
        assert addr.blank?, "Blank address isn't blank?"
        %w{ name line1 city state postal_code }.each do | attr |
            assert addr.blank?
            addr[ attr ] = "something"
        end
        refute addr.blank?
    end

    def test_separated_name
        addr=Address.new( name: 'John D McAuthor' )
        assert_equal 'John', addr.seperated_name[:first]
        assert_equal 'McAuthor', addr.seperated_name[:last]
    end

    def test_selective_validations
        addr=Address.blank
        assert addr.save
        addr.enable_validations
        refute addr.save
        %w{ name line1 city state postal_code }.each do | attr |
            addr[ attr ] = "something"
        end
        assert addr.save
        addr.enable_validations include_email: true
        refute addr.save
        addr.email = "test" # <- no '@'
        refute addr.save
        addr.email = "test@test.com" # <- no '@'
        assert addr.save
        addr.enable_validations include_phone: true
        refute addr.save
        addr.phone = "555-555-5555"
        assert addr.save
    end

    def test_converting_to_string
        addr = skr_addresses(:home)
        assert_equal "home\n12727 Southview Dr\nHolts Summit Missouri, 65043", addr.to_s
    end

end
