module Skr

    class VoLine < Skr::Model

        acts_as_uom

        is_sku_loc_line parent: 'voucher'

        belongs_to :voucher
        belongs_to :sku_vendor
        belongs_to :po_line
        has_one :sku, :through => :sku_vendor, export: true

        validates :sku_vendor, :voucher,   set: true
        validates :sku_code, :description, :presence => true

        validate :qty, numericality: { gt: 0 }

        before_validation :set_defaults, one: :create

        private

        def set_defaults
            if po_line
                self.sku_vendor = po_line.sku.sku_vendors.for_vendor( self.voucher.vendor )
                %w{ price sku_code part_code description uom_code uom_size }.each do | attr |
                    self[ attr ] ||= po_line[ attr ]
                end
            end
            true
        end
    end


end # Skr module
