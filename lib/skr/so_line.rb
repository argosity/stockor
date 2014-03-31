module Skr

    class SoLine < Skr::Model

        acts_as_uom
        is_order_line parent: 'sales_order'

        belongs_to :sales_order
        belongs_to :sku_loc, export: true
        has_one :sku, :through => :sku_loc, export: true
        has_one :location, :through => :sales_order
        # has_many :pt_lines,  :before_add=>:setup_new_pt_line, :inverse_of=>:so_line
        # has_many :inv_lines, :before_add=>:setup_new_inv_line, :inverse_of=>:so_line

        validates :sales_order, :sku_loc,  set: true

        validates :price, :qty, :numericality=>true
        validates :qty_allocated, :numericality=>{ :greater_than_or_equal_to=>0 }
        validate  :ensure_allocation_is_correct

        export_methods :extended_price, :optional=>false

        has_additional_events :qty_change

        before_validation   :set_defaults_from_associations

        before_create  :allocate_max_available
        before_create  :ensure_so_is_open
        before_destroy :ensure_deleteable


        scope :allocated, ->{ where( "#{table_name}.qty_allocated > 0" ) }
        scope :unallocated, ->{ where( "#{table_name}.qty_allocated < #{table_name}.qty - #{table_name}.qty_invoiced - #{table_name}.qty_canceled") }
        scope :pickable,  ->{ where( "#{table_name}.qty_allocated > #{table_name}.qty_picking" ) }
        export_scope :unshipped, lambda {|unused=nil|
            includes(:sku,:sales_order)
            .references(:sku,:sales_order)
            .where( "sales_orders.state in ('pending','saved','authorized') and so_lines.qty > so_lines.qty_invoiced + so_lines.qty_canceled and skus.does_track_inventory='t'")
        }

        def location=(location)
            self.cancel!
            self.sku_loc = self.sku.sku_locs.find_or_create_for( location )
            self.allocate_max_available
            self.save!
            self
        end


        def allocate_max_available
            self.qty_allocated = [ 0, [ sku_loc.qty_available+qty_allocated, qty ].min ].max if self.sku.does_track_inventory?
            self
        end

        def is_fully_allocated?
            self.qty_allocated >= qty - qty_invoiced - qty_canceled
        end

        def update_qty_shipped
            inv_qty = self.inv_lines.sum(:qty)
            update_attributes( :qty_invoiced=> inv_qty, :qty_allocated => [ qty_allocated - inv_qty, 0 ].max )
        end

        def pickable_qty
            qty_allocated - qty_picking
        end

        def update_qty_picking
#            update_attributes( :qty_picking=> self.pt_lines.is_picking.sum(:qty) )
        end

        def for_public( user=nil )
            json = super
            json.merge( self.as_json( :only=>%w{ qty_canceled qty_invoiced is_revised } ) )
        end

        def ea_qty_allocated
            qty_allocated * uom_size
        end

        def cancel!
            self.update_attributes :qty_allocated => 0, :qty_picking=> 0
#            pt_lines.is_picking.each{ |ptl| ptl.cancel! }
        end

        private


        def fire_after_save_events
            %w{ allocated picking invoiced canceled }.each do | event |
                if changes[ "qty_#{event}" ]
                    fire_event( :qty_change )
                    break
                end
            end
            super
        end

        def set_defaults_from_associations
            self.uom         = sku.uoms.default if self.uom_code.blank?
            self.description = sku.description if self.description.blank?
            self.sku_code    = sku.code        if self.sku_code.blank?
            self.price     ||= sku.price_for( self.sales_order.customer )
            true
        end

        def setup_new_inv_line( line )
            line.qty = self.sku.is_other_charge? ? self.qty : self.qty_allocated
            setup_new_line(line)
        end
        def setup_new_pt_line( line )
            line.qty = self.sku.is_other_charge? ? self.qty : self.pickable_qty
            setup_new_line(line)
        end

        def setup_new_line(line)
            line.price    = self.price
            line.sku_loc  = self.sku_loc
            line.uom      = self.uom
            line.has_free_shipping = self.has_free_shipping
            true
        end

        def ensure_allocation_is_correct
            return true unless qty_allocated_changed?
            diff = qty_allocated - qty_allocated_was
            if qty_allocated > qty
                errors.add(:qty_allocated, "must be less than qty ordered (#{qty})")
            end
            if diff > 0 && sku_loc && diff > sku_loc.qty_available
                errors.add(:qty_allocated, "new allocation (#{qty_allocated}) - old allocation (#{qty_allocated_was}) can't be more than qty available (#{ sku_loc.qty_available })")
                return false
            end
            true
        end


        def ensure_so_is_open
            unless self.sales_order.open?
                errors.add(:base,"Cannot add item #{self.sku_code} to non-open Sales Order")
                return false
            end
            true
        end

        def ensure_deleteable
            if qty_allocated > 0
                errors.add(:base,'Cannot delete line when allocated')
                return false
            end
            if qty_invoiced > 0
                errors.add(:base,"Cannot delete line after it's shipped")
                return false
            end
            true
        end



    end


end # Skr module
