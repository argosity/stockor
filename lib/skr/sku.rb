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

        before_create :set_record_defaults
        after_create  :create_associated_records

        scope :with_vendor_sku_code, lambda { | vendor_sku |
            joins(:sku_vendors).where(['sku_vendors.code like ?',vendor_sku])
        }, :export=>true

        scope :in_location, lambda { | location_id |
            includes(:locations).references(:loations).where(['sku_locs.location_id=?',location_id])
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
            locations.each(&:rebuild!)
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
            if default_uom_code_changed? && default_uom.nil?
                errors.add( :default_uom_code, "does not exist on UOMs" )
            end
        end

        # Setup the associations after create
        def create_associated_records
            if locations.empty?
                self.locations.create({ sku: self, location: Location.default })
            end
            true # don't cancel save op
        end

        # Set the default values for the Sku if they are not present
        def set_record_defaults
            if self.default_vendor.blank? && self.sku_vendors.any?
                self.default_vendor = self.sku_vendors.at(0).vendor
            end
            self.uoms << Uom::EA.dup if self.uoms.empty?

            self.can_backorder      = Core.config.skus_backorder_default if self.can_backorder.nil?
            self.gl_asset_account ||= self.tenant.default_gl_asset_account
            self.default_uom_code ||= self.uoms.first.code

            true # don't cancel save op
        end

    end

end # Skr module


__END__

# to merge later

        def for_public( user=nil, options={} )
            self.as_json(:only=>%w{ id code description default_uom_code is_other_charge is_discontinued can_backorder })
            .merge({
                'uoms'=>uoms.map{|uom|uom.for_public(user,options[:uoms])}
            })
            .merge({ default_price: default_price })
            end

        has_many :location_records, :class_name=>'Location', :source=>:location, :through=>:locations

        has_one :default_sku_vendor, ->(sku) {
            sku.is_a?(Sku) ? where( { vendor_id: sku.default_vendor_id } ) :
            where( "vendor_id=skus.default_vendor_id" ).references(:sku).includes(:sku)
        }, :class_name=>'SkuVendor'

        has_many :item_skus, :dependent=>:destroy
        has_many :items, :through=>:item_skus, :source=>:item
        has_many :images, :through=>:item_skus

        scope :on_web, lambda { | limited=true |
            limited.to_s == 'true' ? joins( :item_skus ) :
            joins( "left join item_skus on item_skus.sku_id=sku_locs.sku_id" ).where( "item_skus.id is null" )
            }, :export=>true

        export_associations :default_sku_vendor
        export_associations :images

        after_update :touch_items

        attr_protected :ma_cost

        before_validation :set_default_associations, :on=>:create

        export_scope :only_back_ordered, lambda{ | usused=nil |
            select('skus.*,ttls.qty_on_hand, ttls.qty_on_orders')
                .joins( "join ( select sku_locs.sku_id,
                             sku_locs.qty as qty_on_hand, sum(so_lines.qty) as qty_on_orders from sku_locs
                             join so_lines on so_lines.sku_loc_id = sku_locs.id and so_lines.qty > 0
                             join sales_orders on sales_orders.id = so_lines.sales_order_id and sales_orders.state
                                 in ('pending','saved','authorized')
                             group by sku_locs.sku_id, sku_locs.qty having sum(so_lines.qty) > sku_locs.qty
                         ) ttls on ttls.sku_id = skus.id" )
            .where("skus.does_track_inventory='t'")
        }



        def web_sku_loc
            sku_locs.detect{ |sl| sl.location_id = Tenant.current.website.location_id }
        end

        def default_price
            default_uom ? default_uom.base_price : BigDecimal.new('0')
        end


        def set_location_ids=( ids )
            ( ids - self.location_record_ids ).each do | missing |
                SkuLoc.create!( { :sku=>self,:location=>Location.find(missing) } )
            end
            ( self.location_record_ids - ids ).each do | removed |
                bad = self.locations.where({:location_id=>removed})
                self.locations.delete( bad ) if bad
            end
        end



    def touch_items
        items.each(&:touch)
    end

    private
