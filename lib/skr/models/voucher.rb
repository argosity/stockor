module Skr

    # A voucher is a record of a {Vendor}'s demand for payment, or a record of
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

        has_sku_loc_lines

        belongs_to :vendor,   export: true
        belongs_to :customer, export: true

        belongs_to :purchase_order
        belongs_to :terms, :class_name=>'Skr::PaymentTerm', export: true
        belongs_to :location

        has_many :gl_transactions, :as=>:source
        has_many :lines, :class_name=>'Skr::VoLine', export: { writable: true },
                 :inverse_of=>:voucher, :autosave=>true, validate: true

        before_validation :set_defaults, :on=>:create

        scope :with_details, lambda { | *args |
            compose_query_using_detail_view( view: 'vo_details', join_to: 'voucher_id' )
        }, export: true

        scope :unpaid, lambda{ | unused=nil |
            where(['vouchers.state <> ? and payment_lines.id is null', 'pending']).includes(:payment_line)
        }, export: true

        enum state: {
            pending:    0,
            confirmed:  5,
            paid:      10
        }

        state_machine do
            state :pending, initial: true
            state :confirmed
            state :paid

            event :mark_confirmed do
                transitions from: :pending, to: :confirmed
                before :record_confirmation_in_gl
            end

            event :mark_paid do
                transitions from: :confirmed, to: :paid, guards: :ensure_payment_line
                before :record_payment_in_gl
            end


        end

        def po_receipt=(por)
            self.vendor = por.vendor
            self.purchase_order = por.purchase_order
            self.terms = self.purchase_order.terms
            self.refno = por.refno
        end

        # Should only be called before saving, once all setting is done.
        # Will be called in a :before_save, but may be called earlier if
        # terms or other calculated values are needed
        def set_defaults
            if self.purchase_order
                self.vendor   = self.purchase_order.vendor
                self.terms  ||= self.purchase_order.terms
            end
        end

      private

        def ensure_payment_line
            payment_line.present?
        end

        def record_confirmation_in_gl
            self.confirmation_date ||= Date.today
            GlTransaction.push_or_save(
              :owner   =>  self, amount: total,
              :debit   =>  vendor.gl_payables_account,
              :credit  => GlAccount.default_for( :inventory_receipts_clearing ),
              :options => { description: "Voucher #{self.visible_id}" }
            )
            true
        end

        def record_payment_in_gl
            gl = self.gl_transactions.build({
                :source      =>self,
                :location    => self.purchase_order.location,
                :amount      =>self.total,
                :description =>'Voucher Payment' })
            gl.credit.account = self.vendor.gl_payables_account
            gl.debit.account  = self.payment_line.payment.bank_account.gl_account
            gl.save!
        end

    end


end # Skr module
