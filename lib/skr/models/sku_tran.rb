module Skr

    # In Stockor, inventory related transactions are not performed directly on the model(s)
    #
    # Instead a SkuTran is created, and it is responsible for adjusting
    # either the cost or qty of the inventory.  By doing so, all inventory
    # changes is logged and can be referred to in order to audit
    # changes.
    class SkuTran < Skr::Model

        acts_as_uom

        is_immutable

        belongs_to :sku_loc
        has_one :location, :through => :sku_loc

        belongs_to :origin, :polymorphic=>true

        has_one :gl_transaction, :as=>:source, :inverse_of=>:source

        validates :sku_loc, :set=>true
        validates :origin_description, :presence=>true
        validates :prior_mac,          :numericality=>true

        validate  :ensure_cost_and_qty_present

        attr_accessor :credit_gl_account
        attr_accessor :debit_gl_account
        attr_accessor :gl_tran_description_text

        after_save  :adjust_sku_loc_values
        after_save  :create_needed_gl_transaction
        before_save :calculate_mac

        attr_accessor :allocate_after_save

        # @param sl [SkuLoc] set's the sku loc and also sets {#prior_qty} and {#prior_mac}
        def sku_loc=(sl)
            super
            self.prior_qty = sl.qty
            self.prior_mac = sl.mac
        end

        # @return [Fixnum] {#qty} expressed in terms of single UOM
        def ea_qty
            self.qty * ( self.uom_size || 1 )
        end

        # @return [String] a description intended for use by the #{GlTransaction}
        # def description_for_gl_transaction(gl)
        #     self.origin_description
        # end

        private

        # sets {#mac} to the correct amount for the {SkuLoc}.
        # To calculate the MAC, the {SkuLoc#onhand_mac_value} is added to {#cost}
        # and then divided by #{SkuLoc#qty} + {#ea_qty}
        def calculate_mac
            new_qty = sku_loc.qty + self.ea_qty
            return true if self.mac.present?
            if new_qty.zero?
                self.mac = BigDecimal.new(0)
            elsif cost
                self.mac = ( sku_loc.onhand_mac_value + cost ) / new_qty
            else
                self.mac = sku_loc.onhand_mac_value
            end
            true
        end

        # If {#cost} is non-zero, then create a {GlTransaction}
        def create_needed_gl_transaction
            Skr::Core.logger.debug "Recording SkuTran in GL, mac is: #{self.mac}, cost = #{cost}"
            return if self.cost.nil? || self.cost.zero?
            GlTransaction.push_or_save(
              owner: self, amount: cost,
              debit: debit_gl_account, credit: credit_gl_account
            )
        end

        # Adjusts {SkuLoc#qty} by {#ea_qty}
        def adjust_sku_loc_values
            sl = self.sku_loc
            Skr::Core.logger.debug "Adj +#{ea_qty} Sku #{sl.sku.code} location #{location.code} " +
                                   "from MAC: #{sl.mac} to #{self.mac}, qty: #{sl.qty} += #{ea_qty} #{combined_uom}"
            sl.unlock_fields( :qty, :mac ) do
                sl.mac = self.mac unless self.mac.nan? or self.mac.zero?
                sl.adjust_qty( ea_qty )
                sl.save!
            end
            sl.reload
            sl.allocate_available_qty! if self.allocate_after_save

            Skr::Core.logger.debug "After Adj Qty #{sl.qty}"
        end

        def ensure_cost_and_qty_present
            if ea_qty.zero?
                errors.add( :base, "Transaction has no effect, must change inventory onhand value")
            end
            if cost.present? && cost.nonzero? && debit_gl_account.nil?
                errors.add( :debit_gl_account, "was not specified even though we need to adjust the GL by #{cost}")
            end
        end

    end


end # Skr module
