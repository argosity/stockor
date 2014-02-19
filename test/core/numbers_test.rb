require_relative '../test_helper'

describe Skr::Core::Numbers do

    Num = Skr::Core::Numbers


    def test_percnum
        assert Num::PercNum.new( '5%'  ).is_percentage?, "is a percentage"
        assert Num::PercNum.new( '5% ' ).is_percentage?, "is a percentage"
        assert Num::PercNum.new( '5.3 % ' ).is_percentage?, "is a percentage"
        refute Num::PercNum.new( '$5.3 ' ).is_percentage?, "is not a percentage"
        # this is debatable, but we have to draw the line somewhere
        refute Num::PercNum.new( '%5.3 ' ).is_percentage?, "is a percentage"

        assert_equal '95.0',  Num::PercNum.new( '5'  ).debit_from(100).to_s
        assert_equal '95.0',  Num::PercNum.new( '5%' ).debit_from(100).to_s
        assert_equal '105.0', Num::PercNum.new( '5%' ).credit_to(100).to_s
        assert_equal '95.0',  Num::PercNum.new( '-5%').credit_to(100).to_s

        assert_equal '137.38449', Num::PercNum.new( '33.383%' ).credit_to(103).to_s
        assert_equal '68.61551',  Num::PercNum.new( '33.383%' ).debit_from(103).to_s
    end


end
