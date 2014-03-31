module Skr

    # A SalesOrder is a record of a customer's desire to purchase one or more {Sku}s.
    #
    #   customer = Customer.find_by_code "VIP1"
    #   so = SalesOrder.new( customer: customer )
    #   Sku.where( code: ['HAT','STRING'] ).each do | sku |
    #       so.lines.build(
    #         sku_loc: sku.sku_locs.default
    #   )
    #   end
    #   so.save

    class SalesOrder < Skr::Model

        has_visible_id
        has_random_hash_code
        is_a_state_machine
        is_order_like

        belongs_to :customer, export: true
        belongs_to :location, export: true
        belongs_to :terms, :class_name=>'PaymentTerm', export: { writable: true }
        belongs_to :billing_address,  :class_name=>'Address', export: { writable: true }
        belongs_to :shipping_address, :class_name=>'Address', export: { writable: true }

        has_many   :lines, ->{ order(:position) }, :class_name=>'SoLine', :inverse_of=>:sales_order,
                   :dependent=>:destroy, export: { writable: true }
        has_many   :skus, :through=>:lines
        has_many   :pick_tickets, :inverse_of=>:sales_order, :before_add=>:setup_new_pt
        # has_many   :invoices,     :inverse_of=>:sales_order, :before_add=>:setup_new_invoice,
        #            listen: { save: 'on_shipment' }

        validates :location, :terms, :customer, :order_date, :presence=>true
        validate  :ensure_location_changes_are_valid

        delegate_and_export :customer_code, :customer_name
        delegate_and_export :billing_address_name
        delegate_and_export :location_code, :location_name
        delegate_and_export :terms_code,    :terms_description

        after_save        :update_associated_records

        scope :with_amount_details, lambda { | *args |
            compose_query_using_detail_view( view: 'so_amount_details', join_to: 'sales_order_id' )
        }, export: true

        scope :with_allocation_details, lambda {
            compose_query_using_detail_view( view: 'so_allocation_details', join_to: 'sales_order_id' )
        }

        scope :open, lambda { | open=true |
            where("state in ('pending','saved','authorized')") if open
        }, export: true

        scope :allocated, lambda { | open=true |
            with_allocation_details.where('details.number_of_lines_allocated>0')
        }, export: true

        scope :fully_allocated, -> {
            allocated.where('details.number_of_lines=details.number_of_lines_allocated')
        }, export: true

        scope :pickable, ->(unused=nil){
            allocated.where("( ship_partial='t' and details.number_of_lines_allocated > 0 ) " +
              " or ( details.number_of_lines=details.number_of_lines_fully_allocated)" )
        }, export: true

        def self.sales_history( ndays )
            self.connection.execute( "#{skr_prefix}so_dailly_sales_history" ).values
        end

        state_machine :initial => :pending do
            event :mark_saved do
                transition :pending => :saved
            end
            event :mark_authorized do
                transition [:pending,:saved] => :authorized
            end
            event :mark_complete do
                transition all=>:complete
            end
            event :mark_canceled do
                transition ( any - :complete ) => :canceled
            end

            before_transition any => :canceled, :do => :cancel_all_lines
            before_transition [:authorized] => :canceled, :do => :cancel_authorizations
        end

        def initialize(attributes = {})
            super
            self.order_date = Date.today
        end

        def customer=(cust)
            super
            self.terms ||= cust.terms
            self.is_tax_exempt    = cust.is_tax_exempt        if     self.is_tax_exempt.nil?
            self.billing_address  = cust.billing_address.dup  unless self.billing_address.present?
            self.shipping_address = cust.shipping_address.dup unless self.shipping_address.present?
        end

        def open?
            ! [ :complete,:canceled ].include?( self.state_name )
        end

        private

        def prep_descendant_record( rec )
            rec.customer = self.customer
            rec.location = self.location
            if line = self.ship_line
                rec.shipping_option = self.shipping_option
                rec.shipping_charge = line.price
            end
        end

        def setup_new_invoice( inv )
            prep_descendant_record( inv )
            self.lines.each do | so_line |
                inv.lines << so_line.inv_lines.build
            end
            true
        end

        def setup_new_pt(pt)
            prep_descendant_record( pt )
            self.lines.each do | so_line |
                pt.lines << so_line.pt_lines.build if so_line.pickable_qty > 0
            end
            true
        end

        def update_associated_records
            if location_id_changed?
                self.lines.each{ |l| l.location = self.location }
            end
        end

        def ensure_location_changes_are_valid
            return true unless changes['location_id']
            errors.add(:location, 'cannot be changed unless sales order is open') if ! open?
            current = self.sku_ids
            setup   = location.sku_locs.where( sku_id: current ).pluck('sku_id')
            missing = current - setup
            if missing.any?
                codes = Sku.where( id: missing ).pluck('code')
                errors.add(:location, "#{location.code} does not have skus #{codes.join(',')}")
            end
        end

        private

        def cancel_all_lines
            self.pick_tickets.each{ |pt| pt.cancel! }
            self.lines.each{ | soline | soline.cancel! }
        end


        def on_shipment(inv)
            if lines.unshipped.none?
                self.cancel_all_lines
                self.mark_complete!
            end
        end


    end


end # Skr module
