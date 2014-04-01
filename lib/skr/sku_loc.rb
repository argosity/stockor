module Skr

    # Next to the {Sku} class, SkuLoc is the second most integral model in Stockor.  It tracks
    # which Skus are setup in each location and the related quantity information about them
    #
    # It is also the model that is linked to by other models that need to refer to a sku's location
    # such as the lines on {PurchaseOrder}, Quotes, {SalesOrder}, PickTickets, and Invoices
    class SkuLoc < Skr::Model

        belongs_to :sku,      export: true
        belongs_to :location, export: true

        has_many :so_lines, inverse_of: :sku_loc,  extend: Concerns::SO::Lines, listen: { qty_change: :update_so_qty }
        has_many :pt_lines, :inverse_of=>:sku_loc, extend: Concerns::PT::Lines, listen: { save: :update_qty_picking }

        has_many :sku_vendors, :primary_key=>:sku_id, :foreign_key=>:sku_id

        delegate_and_export :location_name, :location_code
        delegate_and_export :sku_code,      :sku_description

        validates :mac, numericality: true
        validates :sku, :location, presence: true
        validates :sku, uniqueness: { scope: :location_id, message: "SKU may not be in the same location twice" }

        export_methods :qty_available

        locked_fields :qty, :mac

        has_additional_events :qty_change

        # @return [BigDecimal] the value of inventory for {Sku} in this {Location}
        def onhand_mac_value
            qty*mac
        end

        # @return [Fixnum] the qty that is not allocated, picking or reserved
        def qty_available
            qty - qty_allocated - qty_picking - qty_reserved
        end

        # Adjust the on hand qty.  Can only be called while qty is unlocked
        # @example
        #   sl = SkuLoc.first
        #   sl.unlock_fields( :qty ) do
        #     sl.adjust_qty( 10 )
        #     sl.save!
        #   end
        # @param [Fixnum] qty the amount to adjust the onhand qty by
        # @return [Fixnum] new qty on hand
        def adjust_qty( qty )
            self.qty += qty
        end

        # Rebuilding is sometimes needed for cases where the location's
        # allocation/on order/reserved counts get out of sync with the
        # SalesOrder counts.  This forces recalculation of the cached values
        def rebuild!
            self.update_attributes({
                qty_picking: pt_lines.pt_lines.picking_qty,
                qty_allocated: self.so_lines.pending.allocated.eq_qty_allocated
              })
        end

        # Allocate the maximum available quantity to {SalesOrder}
        # that are not currrently allocated
        def allocate_available_qty!
            update_so_qty
            so_lines.unallocated.order(:created_at).each do | sol |
                sol.sku_loc = self
                sol.allocate_max_available
                sol.save
                break if qty_allocated <= 0
            end
        end

        private

        def fire_after_save_events
            fire_event(:qty_change) if qty_changed?
        end

        # Caches the qty of skus that are allocated to sales orders in the {#qty_allocated} field
        def update_so_qty( so_line=nil )
            #allocated = so_lines.allocated.inject(0){  |sum, l| sum + l.ea_qty_allocated }
            self.update_attributes({ qty_allocated: self.so_lines.pending.allocated.eq_qty_allocated })
        end

        def update_qty_picking( pt=nil )
            update_attributes( :qty_picking=> self.pt_lines.picking.ea_picking_qty )
        end

    end


end # Skr module
