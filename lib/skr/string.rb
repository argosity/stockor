module Skr

    module String

        def  self.number_with_delimiter(number)
            ('%0.2f' % number).reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
        end

    end

end
