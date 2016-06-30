module Skr

    # Invoices constitute a demand for payment for goods that have been delivered to a {Customer}.
    # A invoice contains:
    #
    #   * Customer contact information
    #   * An inventory location that goods will be taken from.
    #   * The customer provided {PurchaseOrder} Number
    #   * The Payment Terms that were extended. This will control how much time the Customer has to pay the invoice in full.
    #   * One or more SKUs, the quantity desired for each and the selling price for them.
    #
    # While an {Invoice} often originates with a {SalesOrder}, it does not have to.
    # Sales that take place in a retail environment where the customer selects
    # the goods and pays for them immediately do not require a sales order record.
    #
    # Once an invoice is saved, it immediately removes the SKUs from the {SkuLoc}
    # and generates corresponding General Ledger entries debiting the asset account
    # and crediting the customers receivables account.
    #
    # When payment is received against the Invoice,
    # the receivables account is debited and the payments holding account is credited.
    #
    #     invoice = Invoice.new( customer: Customer.find_by_code("ACME")
    #     invoice.lines.build({ sku: Sku.find_by_code('LABOR'), qty: 1, price: 8.27 })
    #     invoice.save

    class Invoice < Skr::Model

        has_visible_id
        has_random_hash_code
        has_gl_transaction
        is_order_like

        belongs_to :sales_order,      export: true
        belongs_to :customer_project, export: true
        belongs_to :customer,         export: true
        belongs_to :location,         export: true
        belongs_to :pick_ticket,      inverse_of: :invoice,           export: true
        belongs_to :terms,            class_name: 'Skr::PaymentTerm', export: true
        belongs_to :billing_address,  class_name: 'Skr::Address',     export: { writable: true }
        belongs_to :shipping_address, class_name: 'Skr::Address',     export: { writable: true }

        has_many :gl_transactions, :as=>:source

        has_many :lines, -> { order(:position) },
                 class_name: 'Skr::InvLine', inverse_of: :invoice,
                 extend: Concerns::INV::Lines, export: { writable: true }

        has_many :payments, inverse_of: :invoice,
                 extend: Concerns::INV::Payments,
                 listen: { save: :apply_payment },
                 export: { writable: true }

        before_validation :set_defaults, on: :create

        validates :customer, :location, set: true
        validate  :ensure_unlocked, :ensure_location_matches_so

        # used to update customer account balances when invoices created / paid
        scope :open_for_customer, lambda{ | customer |
            where(state: :open, customer_id: customer.is_a?(Customer) ? customer.id : customer)
        }, export: true

        scope :with_sku_id, lambda { | sku_id |
            joins("join (select skr_sku_inv_xref.invoice_id as invoice_id from skr_sku_inv_xref " +
                  "where sku_id=#{sku_id.to_i} group by skr_sku_inv_xref.invoice_id) as sku_inv " +
                  "on sku_inv.invoice_id = skr_invoices.id")
        }, export: true

        scope :with_details, lambda { |should_use=true |
            compose_query_using_detail_view( view: 'skr_inv_details', join_to: 'invoice_id' )
        }, export: true

        enum state: {
            open:     1,
            paid:     5,
            partialy_paid: 10
        }

        state_machine do
            state :open, initial: true
            state :paid
            state :partialy_paid
            event :mark_paid do
                transitions from: [:open,:partialy_paid], to: :paid
            end
            event :mark_partialy_paid do
                transitions from: :open, to: :partialy_paid
            end
        end

        def initialize(attributes = {})
            super
            # date must be set, otherwise things like terms that are based off of it fail
            self.invoice_date ||= Date.today
        end

        # @return [BigDecimal] total - amount_paid
        def unpaid_amount
            self.total - self.payments.total
        end

        # @return [Boolean] is the invoice paid in full
        def fully_paid?
            unpaid_amount <= 0
        end

        # @return [DateTime] when the invoice is due
        def due_date
            self.terms.due_date_from(invoice_date)
        end

        def is_locked?
            GlPeriod.is_date_locked?(self.invoice_date)
        end

        private

        # set the state if the amount_paid was changed
        def apply_payment(pymnt)
            if self.fully_paid? && self.may_mark_paid?
                self.mark_paid!
            elsif self.payments.total > 0 && self.may_mark_partialy_paid?
                Lanes.logger_debug('paying')

                #self.mark_partialy_paid!

                Lanes.logger_debug('paid')
            end
        end

        def set_defaults

            if pick_ticket
                self.location    = pick_ticket.location
                self.sales_order = pick_ticket.sales_order
            end

            if sales_order
                self.terms          ||= sales_order.terms
                self.form           ||= sales_order.form
                self.customer         = sales_order.customer
                self.po_num           = sales_order.po_num if self.po_num.blank?
                self.billing_address  = sales_order.billing_address   if self.billing_address.blank?
                self.shipping_address = sales_order.shipping_address  if self.shipping_address.blank?
                if self.options && sales_order.options
                    self.options.merge!(sales_order.options)
                else
                    self.options = sales_order.options
                end
            end

            if customer_project
                self.customer = customer_project.customer
                self.po_num = customer_project.po_num if self.po_num.blank?
            end

            if customer
                self.form           ||= customer.get_form('invoice')
                self.billing_address  = customer.billing_address   if self.billing_address.blank?
                self.shipping_address = customer.shipping_address if self.shipping_address.blank?
            end

        end

        def ensure_unlocked
            if is_locked?
                self.errors.add(:invoice_date, "falls on a locked GL Period")
            end
        end

        def ensure_location_matches_so
            if sales_order && location != sales_order.location
                self.errors.add(:location, "#{location.code} must match location that order was taken on (#{sales_order.location.code})")
            end
        end

    end


end # Skr module
