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
        data = { name: 'CASH', number: '1200',credits: [] }
        json = Skr::GlAccount.sanitize_json( data, nil )
        data.delete(:credits)
        assert_equal data, json
    end

    def test_exported_associations
        data = { foo: 'bar', description: 'a test', debits: [], credits: [] }
        json = Skr::GlTransaction.sanitize_json( data, nil )
        assert_equal( data.except(:foo), json )
    end

    def test_blacklisted_attributes
        GlAccount.send :blacklist_json_attributes, :name
        data = { name: 'CASH', number: '1200' }
        json = Skr::GlAccount.sanitize_json( data, nil )
        data.delete( :name )
        assert_equal data, json
    end

    def test_recursive_cleaning
        data = { transaction: { source: 'unk', credits: [ { account_number: '120001' } ] } }
        json = GlManualEntry.sanitize_json( data, nil )
        assert_equal( { transaction: { credits: [ { account_number: '120001' } ] } }, json )
    end

end
