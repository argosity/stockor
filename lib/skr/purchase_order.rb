module Skr

    class PurchaseOrder < Skr::Model

        has_visible_id

        is_a_state_machine

        belongs_to :terms,    export: true, class_name: 'PaymentTerm'
        belongs_to :vendor,   export: true
        belongs_to :location, export: true
        belongs_to :ship_addr, :class_name=>'Address', export: { writable: true }

        has_many :lines, ->{ order(:position) }, :class_name=>'PoLine', :inverse_of=>:purchase_order, export: {writable:true}
        has_many :vouchers

        before_validation :set_defaults, :on=>:create

        validates :vendor,  :location, :terms, :presence=>true

        delegate_and_export :vendor_code, :vendor_name
        delegate_and_export :location_code
        delegate_and_export :terms_code, :terms_description

        export_methods :total

        blacklist_json_attributes :receiving_completed_at

        after_save :set_maybe_completed!

        export_join_tables :details
        export_scope :with_details, lambda { |should_use=true |
            joins('join po_details as details on details.purchase_order_id = purchase_orders.id')
            .select('purchase_orders.*, details.*') if should_use
        }

        export_scope :only_incoming, lambda { |should_use=true|
            with_details.where("state !='received'") if should_use
        }

        state_machine :initial => :pending do
            event :mark_saved do
                transition :pending => :saved
            end

            event :mark_transmitted do
                transition :saved => :transmitted
            end

            event :mark_received do
                transition [:pending, :transmitted, :saved] => :received
            end

            after_transition :on=>:received do | po,trans |
                po.receiving_completed_at = Time.now
            end
        end

        def after_message_transmitted( msg )
            self.mark_transmitted if self.can_mark_transmitted?
        end

        def set_maybe_completed!
            self.mark_received! if :received != self.state_name  && self.lines.incomplete.empty?
        end

        def to_shipping_address
            Address.copy_from(self,'ship_')
        end

        def set_message_fields( msg )
            msg.recipient = self.vendor.payments_address.email_with_name  if msg.recipient.blank?
            msg.subject   = "Purchase Order # #{self.visible_id}"
            attach = msg.attachments.build
            attach.set_type_to_pdf
            pdf = self.as_pdf
            attach.file = pdf
        end

        def as_pdf( opts={} )
            defaults = { :purchase_order => self, :include_received=>false }
            Latex::Runner.new( 'purchase_order', defaults.merge( opts ) ).pdf( "PurchaseOrder_#{self.visible_id}.pdf" )
        end

        def total
            if total = self.read_attribute('total')
                BigDecimal.new(total)
            elsif self.association(:lines).loaded?
                self.lines.inject(0){|sum,line| sum + line.total }
            else
                BigDecimal.new( self.lines.sum('price*qty') )
            end
        end

        def type_identifier
            'Purchase Order'
        end

        private

        def set_defaults
            self.order_date ||= Date.today
            self.terms ||= self.vendor.terms if self.vendor
            self.ship_addr = self.location.address if self.ship_addr.blank? && self.location
        end
    end


end # Skr module
