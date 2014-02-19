require_relative '../test_helper'

describe Skr::Core::Strings do

    # just 'cuz
    Str = Skr::Core::Strings

    def test_random_is_of_proper_length
        assert_equal 12, Str.random.length
        assert_equal 6, Str.random(6).length
    end

    def test_random_doesnt_use_bad_chars
        bad = Str::BAD_RAND_CHARS
        assert bad.present?, 'list of bad random chars is empty'
        0.upto(10).each do | i |
            string = Str.random
            string.each_char do |c|
                refute bad.include?(c), "Random string #{string} included bad char '#{c}'"
            end
        end
    end

    def test_code_identifier_shortens
        # if all words are long engouth to shorten, then it takes an
        # equal number from each
        assert_equal 'GENACMCORP', Str.code_identifier( 'General Acme Corp' )
        # If one word is too short, it'll attempt to make up the difference with
        # later words
        assert_equal 'GENIINCORP', Str.code_identifier( 'General I Incorporated' )
        # If it gets to the end and it's still too short, it'll append the
        # padding char
        assert_equal 'GENERALIBC', Str.code_identifier( 'General I BC' )
        assert_equal 'GENERALIB*', Str.code_identifier( 'General I B.', padding: '*' )
        assert_equal 'FSANSEYEAG', Str.code_identifier( 'Four score and seven years ago', padding: '*' )
        assert_equal 'ALONSBEAST', Str.code_identifier( 'A long s beasty' )
        assert_equal 'GE', Str.code_identifier( 'GE', padding: false )
        assert_equal 'HI33ME', Str.code_identifier( 'Hi 33 Me!', padding: false )
    end
end
