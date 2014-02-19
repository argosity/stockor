require_relative '../test_helper'


class ExportMethodsTest < Skr::TestCase

    def teardown
        GlPosting.send( :remove_method, :account_name ) if GlPosting.new.respond_to?( :account_name )
        GlAccount.exported_methods = {}
    end

    def test_simple_delegation
        refute GlPosting.new.respond_to? :account_name

        GlPosting.send :delegate_and_export, "account_name"

        glp = GlPosting.new
        assert glp.respond_to? :account_name, "Didn't add account_name method"
        assert_nil glp.account_name
        glp.build_account( name: "test123" )
        assert_equal "test123", glp.account_name
        assert GlPosting.has_exported_method?( :account_name, nil ), "Didn't export method"
    end

    def test_dependancy_calculation
        GlPosting.send :delegate_and_export, "account_name"
        GlPosting.send :delegate_and_export, "transaction_notes", optional: false
        assert_equal [:transaction], GlPosting.exported_method_dependancies([])
        assert_equal [:account,:transaction], GlPosting.exported_method_dependancies(['account_name']).sort
    end

end
