module Skr

    class IaReason < Skr::Model

        has_code_identifier

        belongs_to :gl_account, export: true

        delegate_and_export :gl_account_number, :gl_account_name

        validates :gl_account, set: true

    end


end # Skr module
