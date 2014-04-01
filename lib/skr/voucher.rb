module Skr

    # A voucher is a record of a {Vendor}'s demand for payment
    # It transistions through the following states
    #
    #  * Saved; A {PurchaseOrder} has been recieved but an Invoice has not been received fromt the Vendor
    #     * It credit's each line's {Sku#gl_asset_account} and debit's the System default inventory_receipts_clearing
    #  * Confirmed; An Invoice has been received and verified as accurate.
    #     * Debit: {Vendor#gl_payables_account}, Credit: inventory_receipts_clearing
    #  * Paid;  A payment has been made against the Voucher
    #     * Debit {Vendor#gl_payables_account}, Credit: Deposit clearing account
    class Voucher < Skr::Model

        has_visible_id

        is_a_state_machine

        belongs_to :purchase_order, export: true
        belongs_to :vendor,         export: true
        belongs_to :terms, :class_name=>'PaymentTerm', export: true
        belongs_to :location
        #has_one :payment_line,  :as=>:source

        has_many :gl_transactions, :as=>:source
        has_many :lines, :class_name=>'VoLine', export: { writable: true },
                 :inverse_of=>:voucher, :autosave=>true, validate: true

        before_validation :set_defaults, :on=>:create
        around_create  :create_gl_transaction

        validates :freight,        numericality: true
        validates :purchase_order, :vendor, set: true

        delegate_and_export :vendor_code, :vendor_name
        delegate_and_export :terms_code, :terms_description
        delegate_and_export_field :purchase_order, :visible_id

        export_methods :total, :lines_total

        export_scope :with_details, lambda { | *args |
            compose_query_using_detail_view( view: 'vo_details', join_to: 'voucher_id' )
        }

        export_scope :unpaid, lambda{ | unused=nil |
            where(['vouchers.state <> ? and payment_lines.id is null', 'pending']).includes(:payment_line)
        }

        state_machine :initial => :pending do

            before_transition :pending   => :confirmed, :do=> :on_confirmation
            before_transition :confirmed => :paid ,     :do=> :record_payment, :if=>:payment_line

            event :mark_confirmed do
                transition :pending => :confirmed
            end

            event :mark_paid do
                transition :confirmed => :paid
            end

            state :paid do
                validate :payment_line, :is_set=>true
            end

        end

        def payment_line=(pl)
            pl.refno = self.refno
            pl.description = "Payment on PO #{self.visible_id}"
            super
        end

        def total
            ttl = if self.read_attribute('lines_total')
                      BigDecimal.new(total)
                  elsif self.association(:lines).loaded?
                      self.lines.inject(0){|sum,line| sum + line.total }
                  else
                      BigDecimal.new( self.lines.sum('price*qty') )
                  end
            freight + ttl
        end

        def description_for_gl_transaction(gl_tran)
            "Voucher #{self.visible_id}"
        end

        def does_create_own_gl_records?
            true
        end

        private

        def set_defaults
            self.freight  ||= 0.0
            if self.purchase_order
                self.vendor   = self.purchase_order.vendor
                self.location = self.purchase_order.location
                self.terms  ||= self.purchase_order.terms
            end
        end

        def create_gl_transaction
            options = { source: self, location: location }
            GlTransaction.record( options ) do | tran |
                if self.freight.nonzero?
                    tran.add_posting( amount: self.freight,
                      debit: GlAccount.default_for( :inventory_receipts_clearing ),
                      credit: vendor.gl_freight_account
                    )

                end
                yield
            end
        end

        def on_confirmation
            self.confirmation_date ||= Date.today
            GlTransaction.push_or_save(
              owner:  self, amount: total,
              debit:  vendor.gl_payables_account,
              credit: GlAccount.default_for( :inventory_receipts_clearing )
            )
            true
        end

        def record_payment
            gl = self.gl_transactions.build({ :source=>self, :location => self.purchase_order.location, :amount=>self.total, :description=>'Voucher Payment' })
            gl.credit.account = self.vendor.gl_payables_account
            gl.debit.account  = self.payment_line.payment.bank_account.gl_account
            gl.save!
        end

    end


end # Skr module
