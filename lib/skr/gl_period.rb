module Skr

    class GlPeriod < Skr::Model

        is_immutable

        def self.current
            attr = { year: Time.now.year, period: Time.now.month }
            GlPeriod.where( attr ).first || GlPeriod.create( attr )
        end
    end

end
