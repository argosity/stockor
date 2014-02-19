require_relative '../test_helper'


class JsonAttributeAccessTest < Skr::TestCase

    def teardown
        GlAccount.whitelisted_json_attributes = {}
        GlAccount.blacklisted_json_attributes = {:updated_at=>{}, :created_at=>{}}
        GlAccount.exported_associations = {}
    end

    def test_blacklisting
        assert Skr::GlAccount.json_attribute_is_allowed?(:name,  nil )
        assert Skr::GlAccount.json_attribute_is_allowed?('name', nil )

        GlAccount.send :blacklist_json_attributes, :name
        refute Skr::GlAccount.json_attribute_is_allowed?('name', nil )
    end

    def test_whitelisting

        refute Skr::GlAccount.json_attribute_is_allowed?('updated_at', nil )
        GlAccount.send :whitelist_json_attributes, :updated_at
        assert Skr::GlAccount.json_attribute_is_allowed?('updated_at', nil )
    end

end
