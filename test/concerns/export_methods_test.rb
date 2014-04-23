require_relative '../test_helper'


class ExportMethodsTest < Skr::TestCase

    def teardown
        GlPosting.send( :remove_method, :gl_transaction_description ) if GlPosting.new.respond_to?( :gl_transaction_description )
        GlAccount.exported_methods = {}
    end

    def test_simple_delegation
        refute GlPosting.new.respond_to? :gl_transaction_description

        GlPosting.send :delegate_and_export, "gl_transaction_description"

        glp = GlPosting.new
        assert glp.respond_to? :gl_transaction_description, "Didn't add gl_transaction_description method"
        assert_nil glp.gl_transaction_description
        glp.build_gl_transaction( description: "test123" )
        assert_equal "test123", glp.gl_transaction_description
        assert GlPosting.has_exported_method?( :gl_transaction_description, nil ), "Didn't export method"
    end

    def test_dependancy_calculation
        GlPosting.send :delegate_and_export, "gl_transaction_description"
        GlPosting.send :delegate_and_export, "gl_transaction_notes", optional: false
        assert_equal [:gl_transaction], GlPosting.exported_method_dependancies([])
        assert_equal [:gl_transaction], GlPosting.exported_method_dependancies(['gl_transaction_description']).sort
    end

end
