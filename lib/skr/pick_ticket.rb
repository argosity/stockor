module Skr

    class PickTicket < Skr::Model

        has_visible_id
        is_order_like

        belongs_to :sales_order

        has_one :customer, through: :sales_order, export: true
        has_one :location, through: :sales_order
        has_one :terms,    through: :sales_order

        has_many :lines, ->{ order(:position) }, class_name: 'PtLine', inverse_of: :pick_ticket,
                 extend: Concerns::PT::Lines, autosave: true, export: { writable: true }

        scope :with_details, lambda { | *args |
            compose_query_using_detail_view( view: 'pt_details', join_to: 'pick_tickets_id' )
        }, export: true

        delegate :bill_addr, :to=>:sales_order

        # If true, the PickTicket (and it's lines) will be marked as complete once it's saved
        json_attr_accessor :mark_complete

        after_save :check_for_mark_completed

        validates  :sales_order, set: true

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

        def check_for_mark_completed
            self.cancel! if self.mark_complete
        end

        def cancel!
            update_attributes({ :is_complete=> true })
            lines.each do | line |
                line.update_attributes :is_complete=>true
            end
        end

        # def maybe_cancel
        #     if self.lines.is_picking.empty?
        #         update_attributes :is_complete=>true
        #     end
        # end

        def on_shipment(inv)
            if shipped_at
                errors.add(:invoice, 'already exists and cannot be changed')
                return false
            end
            self.invoice = inv
            self.is_complete=true
            self.shipped_at = Time.now
            self.save!
            self.lines.each do | ptline |
                ptline.update_from_invoice( invoice )
            end
        end


    end

    protected

    def set_defaults
fd
    end

end # Skr module
