module Skr

    class PoLine < Skr::Model

        acts_as_uom
        is_order_line parent: 'purchase_order'

        belongs_to :purchase_order, :inverse_of=>:lines
        belongs_to :sku_loc,    export: true
        belongs_to :sku_vendor, export: true

        has_one :sku, :through => :sku_loc, export: true

        has_many :vo_lines, :inverse_of=>:po_line, listen: { create: :update_qty_received! }

        validates :purchase_order, :sku_loc,  set: true
        validates :description,    :sku_code, presence: true
        validates :qty, :price,    numericality: true, allow_nil: false

        locked_fields :qty, :qty_received

        scope :incomplete, ->{ where('qty - qty_received - qty_canceled != 0' ) }

        before_validation :set_defaults, :on=>:create

        def uom=(uom)
            self.uom_size = uom.size
            self.uom_code = uom.code
        end

        def total
            qty * price
        end

        def qty_unreceived
            qty - qty_received - qty_canceled
        end

        def complete?
            qty_unreceived.zero?
        end

        def update_qty_received!( vl=nil )
            unlock_fields :qty_received do
                self.qty_received = vo_lines.sum(:qty)
                self.save( :validate => false )
                if self.complete?
                    self.purchase_order.set_maybe_completed!
                end
            end
        end

        private

        def set_defaults
            self.sku_vendor        = sku_loc.sku.sku_vendors.where( vendor_id: purchase_order.vendor_id ).first
            if sku_loc
                self.sku_code    ||= sku_loc.sku.code
                self.description ||= sku_loc.sku.description
            end
            if sku_vendor
                self.part_code  ||= sku_vendor.part_code
                self.price      ||= sku_vendor.cost
                self.uom_code   ||= sku_vendor.uom_code
                self.uom_size   ||= sku_vendor.uom_size
            end
            true
        end


    end

end # Skr module
