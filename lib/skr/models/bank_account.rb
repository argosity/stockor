module Skr

    class BankAccount < Model

        has_code_identifier from: 'name'

        belongs_to :address,  class_name: 'Skr::Address',
                   export: { writable: true }, dependent: :destroy
    end

end
