require 'ruby-freshbooks'

module Skr::Handlers

    class FreshBooksImport

        def self.handler
            lambda do
                resp = if data['stage'] == 'fetch'
                           Skr::Jobs::FreshBooks::Retrieve.from_request(data)
                       else
                           Skr::Jobs::FreshBooks::Import.from_request(data)
                       end
               json_reply resp
            end
        end

    end

end
