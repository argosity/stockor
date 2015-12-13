module Skr

    class GlPeriod < Skr::Model

        is_immutable

        def self.current
            attr = { year: Time.now.year, period: Time.now.month }
            GlPeriod.where( attr ).first || GlPeriod.create( attr )
        end

        def self.is_date_locked?( date )
            date && GlPeriod.select(:is_locked).where(
                year: date.year, period: date.month, is_locked: true
            ).first
        end
    end

end
