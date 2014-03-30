module Skr

    #### A (S)tock (K)eeping (U)nit (SKU) is the cornerstone of Stockor
    #
    # At it's simplest form a SKU tracks a *resource* that the company controlls.
    # It can be manufactured (by combining other SKUs), purchased, stored, and sold.
    #
    # Although SKUs usually refer to physical item, it may also track intangibles
    # such as "Labor", "Handling", or "Freight"
    #
    class Sku < Skr::Model

        has_code_identifier :from=>'description'

        belongs_to :default_vendor,   class_name: 'Vendor',    export: true
        belongs_to :gl_asset_account, class_name: 'GlAccount', export: true
        belongs_to :default_vendor,   class_name: 'Vendor',    export: true

        has_many :sku_locs, ->{extending Concerns::Sku::Locations },
            inverse_of: :sku, dependent: :destroy,
            export: { writable:true }

        has_many :sku_vendors, ->{ extending Concerns::Sku::Vendors },
            dependent: :destroy,  inverse_of: :sku,
            export: { writable: true, allow_destroy: true }

        has_many :uoms, ->{ order(:size); extending(Concerns::Sku::Uoms) },
            dependent: :destroy, inverse_of: :sku,
            export: { writable: true, allow_destroy: true }

        validates :uoms,                presence: true, :on => :update
        validates :description,         presence: true
        validates :gl_asset_account,    set: true
        validates :default_vendor,      set: true
        validates :default_uom_code,    presence: true, :on => :update
        validate  :ensure_default_uom_exists

        before_validation :set_defaults, :on=>:create
        after_create  :create_associated_records

        scope :with_vendor_part_code, lambda { | vendor_sku |
            joins(:sku_vendors).where( SkuVendor.arel_table[:part_code].matches( vendor_sku ) )
        }, :export=>true

        scope :in_location, lambda { | location_id |
            joins(:sku_locs).where( SkuLoc.table_name => { location_id: location_id } )
        }, :export=>true

        scope :with_qty_details, lambda { | *args |
            compose_query_using_detail_view( view: 'sku_qty_details', join_to: 'sku_id' )
        }, export: { :join_table=>:details }

        scope :only_back_ordered, lambda{ | *args |
            with_qty_details.where("details.qty_on_order > details.qty_on_hand")
        }, export: true


        # Rebuilding is sometimes needed for cases where the location's
        # allocation/on order/reserved counts get out of sync with the
        # SalesOrder counts.  This forces recalculation of the cached values
        def rebuild!
            sku_locs.each(&:rebuild!)
        end

        # Return the uom with code.  Since the UOM's are probably already loaded
        # for the SKU, it makes sense to search over the in-memory collection
        # vs hitting the DB again.
        def uom_with_code( code )
            uoms.detect{|uom| uom.code == code }
        end

        private

        # If the default uom code was changed, make sure the UOM
        # is actually present on the uoms list
        def ensure_default_uom_exists
            if default_uom_code_changed? && uoms.default.nil?
                errors.add( :default_uom_code, "does not exist on UOMs" )
            end
        end

        # Setup the associations after create
        def create_associated_records
            if sku_locs.empty?
                self.sku_locs.create({ sku: self, location: Location.default })
            end
            true # don't cancel save op
        end

        # Set the default values for the Sku if they are not present
        def set_defaults
            if self.default_vendor.blank? && self.sku_vendors.any?
                self.default_vendor = self.sku_vendors.at(0).vendor
            end
            self.uoms << Uom.ea if self.uoms.empty?

            self.can_backorder      = Core.config.skus_backorder_default if self.can_backorder.nil?
            self.gl_asset_account ||= GlAccount.default_for(:asset)
            self.default_uom_code ||= self.uoms.first.code

            true # don't cancel save op
        end

    end

end # Skr module
