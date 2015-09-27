module Skr

    # A location that holds inventory
    class Location < Skr::Model

        has_code_identifier :from=>'name'

        belongs_to :address, export: { writable: true }

        has_many :sku_locs

        validates :gl_branch_code, :presence => true, :numericality=>true, :length=>{:is=>2}

        locked_fields :gl_branch_code

        before_validation :set_defaults, :on=>:create

        # @return [Location] the location that's specified by {Skr::Configuration#default_location_code}
        def self.default
            Location.find_by_code( Skr.config.default_location_code )
        end

      private

        def set_defaults
            self.gl_branch_code ||= Skr.config.default_branch_code
            true
        end

    end
end
