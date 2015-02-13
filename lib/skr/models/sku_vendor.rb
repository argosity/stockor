module Skr

    class SkuVendor < Skr::Model

        acts_as_uom

        belongs_to :sku,    inverse_of:  :sku_vendors, export: true
        belongs_to :vendor, inverse_of:  :sku_vendors, export: true
        has_many :sku_locs, primary_key: :sku_id,      export: true

        delegate_and_export :vendor_code, :vendor_name
        delegate_and_export :sku_code, :sku_description

        validates :list_price, :cost, :uom_size, :numericality=>true, :presence=>true
        validates :uom_code, :part_code, :presence=>true
        validates :sku, :uniqueness=>{ scope: :part_code }

        scope :in_location, lambda { | location |
            location_id = location.is_a?(Numeric) ? location : location.id
            includes(:sku_locs).references(:sku_locs).where(['sku_locs.location_id=?',location_id])
        }, :export=>true


    end

end # Skr module
