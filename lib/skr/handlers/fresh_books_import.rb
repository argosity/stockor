require 'ruby-freshbooks'

module Skr::Handlers

    class FreshBooksImport

        def self.handler
            lambda do
                resp = if data['stage'] == 'fetch'
                           Skr::Jobs::FreshBooks::Retrieve.from_request(data)
                       else
                           Lanes.logger.warn "STARTED IMPORT"
                           Skr::Jobs::FreshBooks::Import.from_request(data) #['domain'], data['api_key'])
                       end
               json_reply resp
            end
        end

    end

end
