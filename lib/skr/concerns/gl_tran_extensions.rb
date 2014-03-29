module Skr
    module Concerns

        module GlTran

            module Postings

                def total
                    total = BigDecimal.new('0')
                    each{ |pst| total+=pst.amount }
                    total
                end

            end

        end
    end
end
