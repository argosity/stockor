require_relative '../test_helper'


class SanitizeJsonTest < Skr::TestCase


    def teardown
        GlAccount.whitelisted_json_attributes = {}
        GlAccount.blacklisted_json_attributes = {}
        GlAccount.exported_associations = {}
        GlPosting.blacklisted_json_attributes = {}
    end

    def test_unknown_attribute_removal
        data = { name: 'CASH', number: '1200', drop_table: 'users' }
        json = Skr::GlAccount.sanitize_json( data, nil )
        assert_equal data.except(:drop_table), json
    end

    def test_cleaning_unwanted_attributes
        data = { name: 'CASH', number: '1200',postings: [] }
        json = Skr::GlAccount.sanitize_json( data, nil )
        data.delete(:postings)
        assert_equal data, json
    end

    def test_exported_attributes
        GlAccount.send :export_associations, :postings, writable: true
        data = { name: 'CASH', number: '1200',postings: [] }

        json = Skr::GlAccount.sanitize_json( data, nil )
        assert_equal data, json
    end

    def test_blacklisted_attributes
        GlAccount.send :blacklist_json_attributes, :name
        data = { name: 'CASH', number: '1200' }
        json = Skr::GlAccount.sanitize_json( data, nil )
        data.delete( :name )
        assert_equal data, json
    end

    def test_recursive_cleaning
        GlAccount.send :export_associations, :postings, writable: true

        data = { name: 'CASH', number: '1200',postings: [ { account_number: '120001' }] }
        json = Skr::GlAccount.sanitize_json( data, nil )
        assert_equal data, json

        GlPosting.send :blacklist_json_attributes, :account_number
        json = Skr::GlAccount.sanitize_json( data, nil )

        data[:postings]=[{}]
        assert_equal data, json
    end

end
