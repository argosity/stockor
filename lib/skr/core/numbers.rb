# * Utility methods that manipulate Numbers

module Skr::Core::Numbers extend self
    # Document the responsibility of the class
    #
    # == Heading
    #
    # Use headings to break up descriptions
    #
    # == Formatting
    #
    # Embody +parameters+ or +options+ in Teletype Text tags. You can also use
    # *bold* or *italics* but must use HTML tags for <b>multiple words</b>,
    # <i>like this</i> and <tt>like this</tt>.
    # - See more at: http://blog.firsthand.ca/2010/09/ruby-rdoc-example.html#sthash.q9Jkcjrl.dpuf


    # ### PercNum
    #
    #
    # A "percnum" is a Stockor invention *(or abomination, depending on your POV)*.
    # It's a string that contains a number and an optional percent sign.
    # If the percent sign is present, the number is treated as a percentage.
    # If desired the user may also input negative numbers which will invert the sense of the method.
    #
    # It's intended to be a user-friendly method to provide one input box for "discount" or "surcharge",
    # and allow the user to input either a flat amount such as 4.50, or a percentage like 20%
    #
    class PercNum
        # @param perc_or_num [BigDecimal,String, Integer] any value that BigDecimal will accept
        def initialize( perc_or_num )
            @is_perc    = !! perc_or_num.to_s.match( /\%\s*$/ )
            @right_side = BigDecimal.new( perc_or_num, 5 )
            if is_percentage?
                @right_side *= 0.01
            end
        end

        # Adds the PercNum to the specified amount.
        # @param amount[BigDecimal] the amount that should be added to the PercNum
        # @return [BigDecimal] The result of either adding (non percent) or multiplying by (percent) the amount
        # @example
        #     PercNum.new( '23.42' ).credit_to(  33 ).to_s  #=> '56.42'
        #     PercNum.new( '25%'   ).credit_to( 100 ).to_s  #=> '125.0'
        def credit_to( amount )
            is_percentage? ? ( 1 + @right_side ) * amount : amount += @right_side
        end

        # Subtracts the PercNum to the specified amount.
        # @param amount[BigDecimal] the amount that should be added to the PercNum
        # @return [BigDecimal] The result of either adding (non percent) or multiplying by (percent) the amount
        # @example
        #     PercNum.new( '23.42' ).debit_from( 42.42 ).to_s  #=> '19.00'
        #     PercNum.new( '25%'   ).debit_from( 100   ).to_s  #=> '75.0'
        def debit_from( amount )
            is_percentage? ? ( 1 - @right_side ) * amount : amount -= @right_side
        end

        ## If PercNum was initialized with a blank string
        def present?
            ! @right_side.zero?
        end

        # Is the PercNum percentage based or absolute
        def is_percentage?
            @is_perc
        end
    end


end
