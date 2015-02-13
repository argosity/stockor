module Skr

    # A pay
    class PaymentTerm < Skr::Model

        has_code_identifier

        def discount
            @discount_percnum ||= Core::Numbers::PercNum.new( read_attribute('discount_amount') )
        end

        def discount_amount=(value)
            @discount_percnum = nil
            super(value)
        end

        def immediate?
            self.days.nil? || self.days.zero?
        end

        def discount_expires_at( start_date = Date.today )
            ( start_date + self.discount_days.days ).to_date
        end

        def due_date_from( start_date = Date.today )
            ( start_date + self.days.days ).to_date
        end

    end
end
