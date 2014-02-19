module Skr

    # A location that holds inventory

    class Location < Skr::Model

        has_code_identifier :from=>'name'

        validates :gl_branch_code, :presence => true, :numericality=>true, :length=>{:is=>2}

        locked_fields :gl_branch_code

        before_validation :set_defaults, :on=>:create

        def self.default
            Location.find_by_code( Core.config.default_location_code )
        end

        private

        def set_defaults
            self.gl_branch_code ||= Skr::Core.config.default_branch_code
            true
        end

    end
end


__END__

# To be migrated over later

has_many :sku_locs
has_many :items, :through=>:items_locations
has_one :image, :as=>:represents, :dependent=>:destroy
belongs_to :address
belongs_to :shipping_setting
belongs_to :payment_processor

export_associations :image, :shipping_setting
export_associations :address, :writable=>true

validates :address,:shipping_setting, :presence => true
def find_or_setup_skuloc_for( sku_id )
    sku_id = sku_id.id if sku_id.is_a?(ActiveRecord::Base)
    sku_locs.where({ sku_id: sku_id }).first || sku_locs.create!({ sku: Sku.find(sku_id), location_id: self.id })
end
