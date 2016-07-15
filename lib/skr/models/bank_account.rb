module Skr

    class BankAccount < Model

        has_code_identifier from: 'name'

        belongs_to :gl_account, class_name: 'Skr::GlAccount', export: true

        belongs_to :address,  class_name: 'Skr::Address',
                   export: { writable: true }, dependent: :destroy

        before_validation :set_defaults, :on=>:create

        def self.default
            account = nil
            if default_id = Skr.system_settings['bank_acount_id']
                account = BankAccount.find(default_id)
            end
            account ||
                BankAccount.find_by_code( Skr.config.default_bank_account_code ) ||
                BankAccount.first
        end

      private

        def set_defaults
            self.gl_account ||= GlAccount.default_for(:bank)
            true
        end

    end


end
