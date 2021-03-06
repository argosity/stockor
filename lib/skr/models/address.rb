module Skr

    # A postal address with optional email and phone number
    # By default all fields may be left blank.
    #
    # Validations may be selectively enabled by using the #enable_validations method
    class Address < Skr::Model

        # @!attribute email
        #   The email address to use

        # @!attribute ensure_not_blank
        #   Must the Address be filled out?  The {#blank?} method must return false
        #   @return [Boolean]
        # @!attribute validate_email
        #   Will the email be validated to meet the {EmailValidator} requirements?
        #   @return [Boolean]
        # @!attribute validate_phone
        #   Should the phone field be validated to be not blank?
        #   @return [Boolean]
        attr_accessor :ensure_not_blank, :validate_email, :validate_phone

        validates  :name, :line1, :city, :state, :postal_code, :presence=>true, :if=>:ensure_not_blank
        validates  :email, :presence=>true, :email=>true, :if=>:validate_email
        validates  :phone, :presence=>true, :if=>:validate_phone

        # @return [Address] a blank copy of an address
        def self.blank
            Address.new({ name: '', line1: '', city: '', state: '', postal_code: '' })
        end

        # @return [String] the name and email formatted for inclusion in an email
        def email_with_name
            "#{name} <#{email}>"
        end

        # fill in missing fields from postal_code using the ZipCode lookup table
        def fill_missing_from_zip
            if ( self.postal_code.present? &&
                 ( self.city.blank? || self.state.blank? ) &&
                 zc = ZipCode.find_by_code( self.postal_code )
               )
                self.city  ||= zc.city
                self.state ||= zc.state
            end
        end

        # @return [Boolean] is all of (name line1 city state postal_code) blank?
        def incomplete?
            return %w{ name line1 city state postal_code }.all?{ |field| self[field].blank? }
        end

        # split the name on space
        # @return [Hash]
        #   * :first [String] Portion of name before first space
        #   * :last  [String] Portion of name after last space
        def seperated_name
            {:first=>name.to_s.split(' ').first, :last=> name.to_s.split(' ').last }
        end

        # enable selected validations
        # @option options [Boolean] :include_email should the email be validated
        # @option options [Boolean] :include_phone should the phone number be validated
        def enable_validations( options = {} )
            self.ensure_not_blank = true
            self.validate_email = options[:include_email]
            self.validate_phone = options[:include_phone]
        end

        # @param include [Array] list of extra fields to include in the address
        # @return [String] Address converted to string, formatted with line breaks in the typical US style of display
        # @example
        #     address = Address.new( name: 'Bob\s Uncle',phone: '877-555-5555', line1: 'PO Box 87',
        #                            city: 'Nowhereville', state: 'Urgandishly' postal_code: 'ASCN 1ZZ' )
        #     address.to_s( :include => :phone ) #=>
        #             Bob's Uncle
        #             PO Box 87
        #             Nowhereville, Urgandishly ASCN 1ZZ
        #             877-5550-5555
        def to_s( include: [], without: [] )
            ret = ""
            [ :name, :line1, :line2 ].each{ |a|
                ret << self[a] + "\n" unless without.include?(a) || self[a].blank?
            }
            ret << city.to_s unless without.include?(:city)
            ret << ' ' + state unless without.include?(:state) || state.blank?
            ret << ', ' + postal_code.to_s unless without.include?(:postal_code) || postal_code.blank?
            include = [ *include ]
            if include.any?
                ret << "\n" + include.map{ | field | self[ field ] }.join("\n")
            end
            ret
        end

        def only_address_fields
            as_json(except: ['id', 'created_by_id', 'created_at', 'updated_by_id', 'updated_at'])
        end

        def to_merchant_format
            fields = only_address_fields
            fields['zip'] = fields.delete('postal_code')
            fields.symbolize_keys
        end

    end


end # end Skr module
