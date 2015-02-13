module Skr

    # A Purchase Order (often abbreviated as PO)
    # is a record of a request to purchase a product from a Vendor.
    # It contains one or more {Sku}, the quantity desired for each and the price offered for them.
    #
    # A Purchase Order progresses through set stages:
    #
    #   * It starts of as "saved"
    #     This state indicates that the PO has been saved but no further action has been under-taken.
    #   * Once it has been sent to the Vendor, it transitions to Sent.
    #   * On reciept of a confirmation from the vendor it becomes Confirmed At this point the PO may be
    #     considered a binding agreement with the {Vendor}.
    #   * When the ordered SKUs are received, the PO will be marked as either Partial or Complete.
    #   * A {PoReceipt} is then created from the Purchase Order.

    class PurchaseOrder < Skr::Model

        has_visible_id

        belongs_to :terms,    export: true, class_name: 'Skr::PaymentTerm'
        belongs_to :vendor,   export: true
        belongs_to :location, export: true
        belongs_to :ship_addr, :class_name=>'Skr::Address', export: { writable: true }

        has_many :lines, ->{ order(:position) }, :class_name=>'Skr::PoLine', :inverse_of=>:purchase_order, export: {writable:true}
        has_many :receipts, class_name: 'Skr::PoReceipt'

        before_validation :set_defaults, :on=>:create

        validates :vendor,  :location, :terms, :presence=>true

        delegate_and_export :vendor_code, :vendor_name
        delegate_and_export :location_code
        delegate_and_export :terms_code, :terms_description

        export_methods :total

        blacklist_attributes :receiving_completed_at

        after_save :set_maybe_completed!

        export_join_tables :details
        export_scope :with_details, lambda { |should_use=true |
            joins('join po_details as details on details.purchase_order_id = purchase_orders.id')
            .select('purchase_orders.*, details.*') if should_use
        }

        export_scope :only_incoming, lambda { |should_use=true|
            with_details.where("state !='received'") if should_use
        }

        state_machine do
            state :open, initial: true
            state :received

            event :mark_received do
                transitions from: :open, to: :received
                before do
                    self.receiving_completed_at = Time.now
                end
            end
        end

        def after_message_transmitted( msg )
            self.mark_transmitted if self.can_mark_transmitted?
        end

        def set_maybe_completed!
            self.mark_received! unless received? or self.lines.incomplete.any?
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

        private

        def set_defaults
            self.location   ||= Location.default
            self.order_date ||= Date.today
            self.terms      ||= self.vendor.terms if self.vendor
            self.ship_addr    = self.location.address if self.ship_addr.blank? && self.location
        end
    end


end # Skr module
