module Skr

    # A SalesOrder is a record of a {Customer}'s desire to purchase one or more {Sku}s.
    # It can be converted into an {Invoice} when the goods are delivered (or shipped)
    # to the {Customer}
    #
    #     customer = Customer.find_by_code "VIP1"
    #     so = SalesOrder.new( customer: customer )
    #     Sku.where( code: ['HAT','STRING'] ).each do | sku |
    #         so.lines.build( sku_loc: sku.sku_locs.default )
    #     end
    #     so.save
    #
    #     invoice = Invoice.new( sales_order: so )
    #     invoice.lines.from_sales_order!
    #     invoice.save


    class SalesOrder < Skr::Model

        has_visible_id
        has_random_hash_code
        is_order_like

        belongs_to :customer, export: true
        belongs_to :location, export: true
        belongs_to :terms, :class_name=>'PaymentTerm', export: { writable: true }
        belongs_to :billing_address,  :class_name=>'Address', export: { writable: true }
        belongs_to :shipping_address, :class_name=>'Address', export: { writable: true }

        has_many   :lines, ->{ order(:position) }, :class_name=>'SoLine', :inverse_of=>:sales_order,
                   extend: Concerns::SO::Lines, export: { writable: true }
        has_many   :skus, :through=>:lines
        has_many   :pick_tickets, :inverse_of=>:sales_order, :before_add=>:setup_new_pt
        has_many   :invoices,     :inverse_of=>:sales_order, listen: { save: 'on_invoice' }

        validates :location, :terms, :customer, set: true
        validates :billing_address, :shipping_address, :order_date, presence: true
        validate  :ensure_location_changes_are_valid

        after_save :check_if_location_changed
        before_validation :set_defaults, on: :create

        delegate_and_export :customer_code, :customer_name
        delegate_and_export :location_code, :location_name
        delegate_and_export :terms_code,    :terms_description
        delegate_and_export :billing_address_name


        # joins the so_amount_details view which includes additional fields:
        # customer_code, customer_name, bill_addr_name, total, num_lines, total_other_charge_amount,
        # total_tax_amount, total_shipping_amount,subtotal_amount
        scope :with_amount_details, lambda { | *args |
            compose_query_using_detail_view( view: 'so_amount_details', join_to: 'sales_order_id' )
        }, export: true

        # joins the so_allocation_details which includes the additional fields:
        # number_of_lines,  allocated_total, number_of_lines_allocated, number_of_lines_fully_allocated
        scope :with_allocation_details, lambda {
            compose_query_using_detail_view( view: 'so_allocation_details', join_to: 'sales_order_id' )
        }

        # a open SalesOrder is one who's state is not "complete" or "canceled"
        scope :open, lambda { | *args |
            where( arel_table[:state].not_in ['complete','canceled'] )
        }, export: true

        # a SalesOrder is allocated if it has one or more lines with qty_allocated>0
        scope :allocated, lambda { | *unused |
            with_allocation_details.where('details.number_of_lines_allocated>0')
        }, export: true

        # a SalesOrder is fully allocated when it has all it's lines allocated
        scope :fully_allocated, -> {
            allocated.where('details.number_of_lines=details.number_of_lines_allocated')
        }, export: true

        # a SalesOrder is considered pickable if either:
        #   ship_partial=true and at least one line is allocated
        #   all lines are fully allocated
        scope :pickable, ->(unused=nil){
            allocated.where("( ship_partial='t' and details.number_of_lines_allocated > 0 ) " +
              " or ( details.number_of_lines=details.number_of_lines_fully_allocated)" )
        }, export: true

        # @return [Array of Array[day_ago,date, order_count,line_count,total]]
        def self.sales_history( ndays )
            qry="select * from #{Skr::Core.config.table_prefix}so_dailly_sales_history where days_ago<#{ndays.to_i}"
            self.connection.execute(qry).values
        end

        state_machine do
            state :open, initial: true
            state :complete
            state :canceled

            event :mark_complete do
                transitions from: :open, to: :complete
            end
            event :mark_canceled do
                transitions from: :open, to: :canceled
                before :cancel_all_lines
            end

        end

        def initialize(attributes = {})
            super
            self.order_date = Date.today
        end

        private

        # When the location changes, lines need to have their sku_loc modified to point to the new location as well
        def check_if_location_changed
            if location_id_changed?
                self.lines.each{ |l| l.location = self.location }
            end
        end

        # The location can only be updated if all the line's sku's are setup in the new location
        def ensure_location_changes_are_valid
            return true unless changes['location_id']
            errors.add(:location, 'cannot be changed unless sales order is open') unless open?
            current = self.sku_ids
            setup   = location.sku_locs.where( sku_id: current ).pluck('sku_id')
            missing = current - setup
            if missing.any?
                codes = Sku.where( id: missing ).pluck('code')
                errors.add(:location, "#{location.code} does not have skus #{codes.join(',')}")
            end
        end

        # Initialize a new {PickTicket} by copying the pickable lines to it
        def setup_new_pt(pt)
            self.lines.each do | so_line |
                pt.lines << so_line.pt_lines.build if so_line.pickable_qty > 0
            end
            true
        end


        # when the order is canceled, inform the lines
        def cancel_all_lines
            self.pick_tickets.each{ |pt| pt.cancel! }
            self.lines.each{ | soline | soline.cancel! }
            true
        end

        def on_invoice(inv)
            self.mark_complete! if may_mark_complete? and lines.unshipped.none?
        end

        def set_defaults
            if customer
                self.billing_address = customer.billing_address   if self.billing_address.blank?
                self.shipping_address = customer.shipping_address if self.shipping_address.blank?
            end
        end

    end


end # Skr module
