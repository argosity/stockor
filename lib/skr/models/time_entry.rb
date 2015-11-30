module Skr

    class TimeEntry < Model

        belongs_to :customer_project, inverse_of: :time_entries, export: true

        belongs_to :lanes_user, class_name: 'Lanes::User', export: true

        validates :start_at, :end_at, :description, presence: true

        validates :customer_project, :lanes_user, set: true


        has_one :inv_line, inverse_of: :time_entry, listen: { create: :mark_as_invoiced }

        def hours
            (end_at - start_at) / 1.hour
        end

        private

        def mark_as_invoiced(inv_line)
            update_attributes(is_invoiced: true)
        end

    end

end
