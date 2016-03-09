require_relative 'base'

module Skr::Jobs::FreshBooks

    class Retrieve < Base

        def process_client(rec)
            rec.slice(*%w{ client_id organization first_name last_name})
        end

        def process_project(rec)
            rec.slice(*%w{project_id name description})
        end

        def process_invoice(rec)
            rec.slice(*%w{invoice_id client_id number amount po_number notes status})
        end

        def process_time_entry(rec)
            if rec['billed'] == '1'
                nil
            else
                rec.slice(*%w{ time_entry_id staff_id project_id hours date notes})
            end
        end

        def process_staff(r)
            r.slice(*%w{staff_id username first_name last_name email})
        end

        def perform(account, token)
            process_each_type(account, token) do | output, index |
                save_progress(output, (index+1).to_f / STEPS.length)
            end
            self
        end

        def self.from_request(req)
            fb = ::FreshBooks::Client.new("#{req['domain']}.freshbooks.com", req['api_key'])
            errors = nil
            begin
                # make a test api call to validate authentication
                resp = fb.client.list(per_page: 1)
                errors = {access: resp['error']} if resp['error']
            rescue SocketError
                errors = {network: 'Unable to resolve account'}
            end
            if errors
                return {success: false, data: {}, errors: errors}
            else
                job = self.perform_later(req['domain'], req['api_key'])
                return {
                    success: true, message: 'Import Validation Started', data: {
                        job: Lanes::Job.status_for_id(job.job_id)
                    }
                }
            end

        end
    end

end
