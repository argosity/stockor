# A custom validator "email".
# Doesn't really validate an email completely
# It simply asserts that the email string has one (and only one)
# @ (at symbol). This is mainly
# to give user feedback and not to assert the e-mail validity.

class EmailValidator < ActiveModel::EachValidator

    # Regex originated from the Devise gem
    REGEX = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

    def validate_each( rec, attr, value)
        unless value.present? && value.match( REGEX )
            rec.errors.add attr, options[:message] || 'does not appear to be a valid email'
        end
    end
end
