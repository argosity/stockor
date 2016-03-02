module Skr

    class PaymentCategory < Model

        has_code_identifier from: 'name'

        belongs_to :gl_account, class_name: 'Skr::GlAccount', export: true

    end

end
