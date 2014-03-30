module Skr

    # An Inventory Adjustment Line.
    # Each model contains the {SkuLoc}, cost, UOM, and qty for a {Sku} to adjust
    #
    # An adjustment starts out in the "pending" state, then when it moves to the "applied"
    # state, each line creates an {SkuTran} record that adjusts the inventory in or out.
    class IaLine < Skr::Model

        acts_as_uom

        belongs_to :inventory_adjustment
        belongs_to :sku_loc, export: true
        has_one :sku, :through => :sku_loc, export: true

        has_one :sku_tran, :as=>:origin
        scope :unapplied, lambda { includes(:sku_tran).references(:sku_tran).where( SkuTran.table_name+'.id is null' ) }

        export_methods :sku_loc_qty, :sku_loc_mac, :optional=>false

        validates :inventory_adjustment, :sku_loc, :inventory_adjustment, :set=>true
        validates :qty,     numericality: true
        validates :uom_code, :uom_size, presence: true
        validate  :ensure_cost_set_properly

        before_save    :set_cost_from_sku_loc
        before_destroy :ensure_adjustment_isnt_applied
        before_update  :ensure_adjustment_isnt_applied

        delegate_and_export :sku_code, :sku_description

        has_locks :adjusting

        # @return [Fixnum] The qty available on the location, expressed in terms of the UOM
        def sku_loc_qty
            ( self.uom_size && self.sku_loc ) ? BigDecimal.new( self.sku_loc.qty ) / self.uom_size : 0
        end

        # @return [BigDecimal] the current moving average cost (mac) on the location, expressed in terms of the UOM
        def sku_loc_mac
            self.sku_loc ? ( self.sku_loc.mac * self.uom_size ) : 0
        end

        # @return [Boolean] has the line been applied
        def is_applied?
            sku_tran.present?
        end

        # @return [Boolean] is the qty negative?
        def is_removing_qty?
            qty && qty <=0
        end

        # The qty for the line expressed in terms of the single UOM
        def ea_qty
            self.uom_size * self.qty
        end

        # @return [BigDecimal] the total value of the line
        def total
            self.ledger_cost * self.qty
        end
        #alias_method :ledger_value, :total

        # @return [BigDecimal] either the current MAC for the sku's location or the cost that was manually set
        def ledger_cost
            if cost_was_set? || is_applied?
                self.cost
            else
                self.sku_loc_mac
            end
        end

        # copies the cost from the sku_loc to the {#cost} field
        def set_cost_from_sku_loc
            if ! cost_was_set?
                self.cost = self.sku_loc_mac
            end
            true
        end


        # Perform the adjustment.  Requires adjusting to be unlocked and {#is_applied?} must be false
        #
        # It creates a {SkuTran} to adjust the inventory, and allocates available qty to the {SoLine}
        def adjust_qty!
            if ! is_adjusting_unlocked? || is_applied?
                raise "Unable to apply line, either not approved or previously applied"
            end
            set_cost_from_sku_loc
            Core.logger.debug( "Adjusting #{self.qty} #{combined_uom} of #{sku_code} into stock")
            self.create_sku_tran!({ :origin=>self, :qty => self.qty, :sku_loc=>self.sku_loc,
                origin_description: "IA #{self.inventory_adjustment.visible_id}:#{self.sku.code}",
                cost: total,
                :uom_size=>self.uom_size, :uom_code=>self.uom_code,
                :debit_gl_account => self.inventory_adjustment.reason.gl_account,
                :credit_gl_account => self.sku.gl_asset_account })

            self.sku_loc.allocate_available_qty!
            true
        end

        private

        # Cost cannot be set if the qty is negative
        def ensure_cost_set_properly
            if cost_was_set? && is_removing_qty?
                errors.add(:cost,'cannot be set if removing qty')
                return false
            end
            true
        end

        def ensure_adjustment_isnt_applied
            if :applied == inventory_adjustment.state_name
                errors.add(:base,'cannot be modified after adjustment is approved and applied')
                return false
            else
                return true
            end
        end




    end


end # Skr module
