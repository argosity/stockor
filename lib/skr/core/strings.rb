module Skr
    module Core
        module Strings

            # list of characters that should not be used
            BAD_RAND_CHARS  = %w{ B 8 o O 0 i l I 1 }

            # characters that should be randomly chosen from
            RAND_CHARS = ( ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a ) - BAD_RAND_CHARS

            # Generates a random string without using commonly confused numbers and letters.
            # It's intended for use in situations where the code will have to be
            # read and re-entered later.
            #
            # The characters in BAD_RAND_CHARS are avoided since they can be confused with one another:
            # @return [String] a random string <length> characters long.
            def self.random( length = 12 )
                1.upto(length).each_with_object(''){|i,s| s << RAND_CHARS[ rand(RAND_CHARS.length) ] }
            end

            # Attempts to shorten a string while keeping it somewhat
            # like it's original self.
            # Useful for suggesting a code for a given entity name.
            # @param string [String] the string to shorten.
            # @param length [Integer] how long the returned code should be
            # @param padding [String] What to pad the code with if it is shorter than length.  False indicates no padding should be performed
            # @return [String] a shortened version of the name with:
            #  * Upper cased
            #  * Spaces stripped
            #  * Made up of a proportional number of chars from each word
            # #### Examples:
            #     Skr::Core::Strings.to_code_identifier('General Acme Corp')       #=> 'GENACMCORP'
            #     Skr::Core::Strings.code_identifier('General I B', padding:false) #=> 'GENERALIB' *(no trailing X)*
            #     Skr::Core::Strings.to_code_identifier('Top Cat', maxlen: 5 )     #=> 'TOCAT'
            def self.code_identifier( string, length:10, padding: 'X' )
                stripped = string.gsub(/\W/, '').upcase
                if stripped.length < length
                    return padding.present? ? stripped.ljust( length, padding ) : stripped
                end
                result = ''
                words = string.gsub(/[^\w\s-]/,'').split(/\s+|-|_/)
                0.upto(words.length + 1).each_with_index do | attempt_num |
                    remainder = length
                    result = ''
                    string = words.each_with_index do | word, index |
                        chars = ( remainder / (words.length-index) + attempt_num )
                        result << word[0...chars]
                        remainder = length - result.length
                    end
                    break if result.length >= length
                end
                result[0...length].upcase
            end

        end
    end
end
