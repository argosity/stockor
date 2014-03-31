require_relative '../test_helper'


class ExportMethodsTest < Skr::TestCase

    def teardown
        GlPosting.send( :remove_method, :transaction_description ) if GlPosting.new.respond_to?( :transaction_description )
        GlAccount.exported_methods = {}
    end

    def test_simple_delegation
        refute GlPosting.new.respond_to? :transaction_description

        GlPosting.send :delegate_and_export, "transaction_description"

        glp = GlPosting.new
        assert glp.respond_to? :transaction_description, "Didn't add transaction_description method"
        assert_nil glp.transaction_description
        glp.build_transaction( description: "test123" )
        assert_equal "test123", glp.transaction_description
        assert GlPosting.has_exported_method?( :transaction_description, nil ), "Didn't export method"
    end

    def test_dependancy_calculation
        GlPosting.send :delegate_and_export, "transaction_description"
        GlPosting.send :delegate_and_export, "transaction_notes", optional: false
        assert_equal [:transaction], GlPosting.exported_method_dependancies([])
        assert_equal [:transaction], GlPosting.exported_method_dependancies(['transaction_description']).sort
    end

end
