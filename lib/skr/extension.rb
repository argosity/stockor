require 'lanes/access/extension'
module Skr

    class Extension < Lanes::Extensions::Definition

        identifier "skr"
        title "Stockor"
        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path

        components 'record-finder', 'select-field', 'calendar'
        client_js_aliases({
            'SC' => 'window.Lanes.Skr.Components'
        })

        def client_bootstrap_data(view)
            gl_accounts = Skr::GlAccount.all.as_json
            {
                default_gl_account_ids: Hash[ Skr.config.default_gl_accounts.map{ |code,number|
                    account = gl_accounts.detect{|gla|gla['number'] == number}
                    [code, account ? account['id'] : 0]
                }],
                gl_accounts: gl_accounts,
                payment_terms: Skr::PaymentTerm.all.as_json,
                locations: Skr::Location.all.as_json,
                templates: Skr::Print::Template.as_json
            }
        end

    end

end

require 'skr'
