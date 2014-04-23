module Skr

    class PtLine < Skr::Model

        acts_as_uom
        is_sku_loc_line parent: 'pick_ticket'

        attr_accessor :qty_to_ship

        belongs_to :pick_ticket, export: true
        belongs_to :sku_loc,     export: true
        belongs_to :so_line

        has_one :inv_line
        has_one :sales_order, :through=>:pick_ticket, export: true
        has_one :sku,         :through => :sku_loc, export: true

        scope :picking, ->{ where({ :is_complete=>false }) }

        delegate_and_export_field  :pick_ticket, :visible_id
        delegate_and_export_field  :sales_order, :visible_id

        before_create :set_defaults#, on: :create

        def update_from_invoice( invoice )
            inv_line = invoice.lines.where({ pt_line_id: self }).first
            if inv_line
                self.update_attributes({ :qty_shipped=> inv_line.qty })
            end
        end

        def cancel!
            self.update_attributes! :is_complete=>true
            self.pick_ticket.maybe_cancel
        end

        def is_invoiceable?
            ! self.is_complete? && self.qty_to_ship.to_i > 0
        end

        def total
            self.price * ( self.qty_to_ship || self.qty )
        end

        private

        def set_defaults

            if self.so_line.blank?
                self.so_line = self.pick_ticket.sales_order.lines.where({ sku_loc_id: self.sku_loc_id }).first
            end

            if self.so_line.blank?
                self.so_line = self.pick_ticket.sales_order.lines.create({
                    sku_loc: self.sku_loc, qty: self.qty, price: self.price,
                    uom: self.uom, description: self.description
                })
                unless self.so_line.valid?
                    self.errors.add(:so_line, "cannot be created because #{self.so_line.errors.full_messages.join(', ')}" )
                    return false
                end
            end

            self.sku_loc     ||= so_line.sku_loc
            self.bin         ||= sku_loc.bin
            self.price       ||= so_line.price
            self.sku_code    = sku_loc.sku.code    if self.sku_code.blank?
            self.description = so_line.description if self.description.blank?
            self.uom         = so_line.uom         if self.uom.blank?
            true
        end


    end


end # Skr module
