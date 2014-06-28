module Skr
    module Workspace
        def self.bootstrap_data(view)
            data = {}
            Extension.each(view) do | definition |
                json = definition.bootstrap_data(view)
                data[ definition.identifier ] = json unless json.blank?
            end
            data['gl_accounts'] = Skr::GlAccount.all
            data
        end
    end
end
