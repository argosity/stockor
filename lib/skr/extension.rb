require 'lanes/access/extension'

module Skr

    class Extension < Lanes::Extensions::Definition

        identifier "skr"
        self.uses_pub_sub = true
        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path
        components "record-finder", "select-field"

        def client_bootstrap_data(view)
            gl_accounts = Skr::GlAccount.all.as_json
            {
                default_gl_account_ids: Hash[ Skr.config.default_gl_accounts.map{ |code,number|
                    account = gl_accounts.detect{|gla|gla['number'] == number}
                    [code, account ? account['id'] : 0]
                }],
                gl_accounts: gl_accounts
            }
        end

    end

end
