require_relative '../test_helper'


class ExportAssociationsTest < Skr::TestCase

    def teardown
        GlAccount.exported_associations = {}
        GlAccount.nested_attributes_options = {}
    end


    def test_writable_option
        assert_empty GlAccount.nested_attributes_options
        GlAccount.send :export_associations, :postings, writable: true
        assert GlAccount.nested_attributes_options[:postings], "didn't add :postings to nested_attributes"
    end

    def test_mandatory_exported_associations
        refute GlAccount.has_exported_method?(:postings, nil)
        GlAccount.send :export_associations, :postings, writable: true, optional: false
        assert GlAccount.has_exported_method?(:postings, nil), "didn't export :postings method"
    end

end
