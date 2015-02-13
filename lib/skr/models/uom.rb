module Skr

    class Uom < Skr::Model

        belongs_to :sku, :inverse_of=>:uoms

        validates :price,  :numericality=>true, :allow_nil=>false
        validates :sku,    :presence=>true, :on=>:update
        validates :code,   :presence=>true
        validates :size,   :numericality => true, :length=>{:minimum=>1}
        validates :weight, :height, :width, :depth, :numericality=>{:greater_than=>0.1}, :allow_nil=>true

        export_methods :combined_uom, mandatory: true

        def combined_uom
            if self.size.nil? || self.code.nil?
                ''
            elsif 1 == self.size
                self.code
            else
                "#{self.code}/#{self.size}"
            end
        end

        def has_dimensions?
            ! self.dimensions.include?(nil)
        end

        def dimensions
            [ width, height, depth ]
        end

        def volume
            if has_dimensions?
                dimensions.inject(:*)
            else
                nil
            end
        end

        def blank?
            self.code.blank? || self.size.to_i == 0
        end


        def self.ea
            Uom.new({ :code=>'EA',:size=>1, :price=>0.0 })
        end

    end


end # Skr module


__END__

        def for_public(user=nil,options={})
            as_json({
                :only=>%w{ code size base_price },
                :methods=>%w{ combined_uom dimensions volume }
            })
        end
