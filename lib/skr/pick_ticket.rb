module Skr

    class PickTicket < Skr::Model

        has_visible_id
        is_order_like

        belongs_to :sales_order
        belongs_to :invoice, inverse_of: :pick_ticket, listen: { create: 'on_invoice' }
        belongs_to :location

        has_one :customer, through: :sales_order, export: true
        has_one :terms,    through: :sales_order

        has_many :lines, ->{ order(:position) }, class_name: 'PtLine', inverse_of: :pick_ticket,
                 extend: Concerns::PT::Lines, autosave: true, export: { writable: true }

        scope :with_details, lambda { | *args |
            compose_query_using_detail_view( view: 'pt_details', join_to: 'pick_tickets_id' )
        }, export: true

        delegate :bill_addr, :to=>:sales_order

        # If true, the PickTicket (and it's lines) will be marked as complete once it's saved
        json_attr_accessor :mark_complete

        before_update :check_for_mark_completed

        validates  :sales_order, set: true
        validates  :lines, presence: true
        export_methods :ship_addr, :bill_addr

        def ship_addr
            sales_order.ship_addr.blank? ? sales_order.bill_addr : sales_order.ship_addr
        end

        def is_tax_exempt?
            self.sales_order.is_tax_exempt?
        end

        def is_other_charge_locked?
            return is_complete
        end

        def cancel!
            update_attributes({ :is_complete=> true })
            lines.each do | line |
                line.update_attributes :is_complete=>true
            end
        end

        private

        def check_for_mark_completed
            return unless self.mark_complete
            assign_attributes :is_complete=>true
            lines.each do | line |
                line.update_attributes :is_complete=>true
            end
            true
        end


        def on_invoice(inv)
            self.update_attributes is_complete: true, shipped_at: Time.now
        end


    end

end # Skr module
