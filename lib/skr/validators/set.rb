# A custom validator "set".  It's similar to :presence validator
# Unlike :presence, :set doesn't care whether the associated record is valid or not, just that it is present
# Also unlike :presence, it only works on belongs_to
class SetValidator < ActiveModel::EachValidator

    def validate_each( record, attribute, value)
        association = record.class.reflect_on_association( attribute )

        if association.nil? || !association.belongs_to?
            raise ArgumentError, "Cannot validate existence on #{record.class} #{attribute}, not a :belongs_to association"
        end

        if record.send( attribute ).nil?
            record.errors.add( attribute, "is not set")
        end

    end
end
