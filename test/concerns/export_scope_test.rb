require_relative '../test_helper'


class ExportScopeTest < Skr::TestCase


    def test_method_creation
        GlPosting.send( :remove_method, :big_query ) if GlPosting.respond_to?( :account_name )

    end

    def test_scope_method_creation
        refute GlPosting.respond_to?(:big_query)
        GlPosting.send( :export_scope, :big_query, ->{} )


        assert GlPosting.respond_to?(:big_query)
    end

end
