require 'ruby-freshbooks'

module Skr::Jobs

    class FreshBooksRetrieve < Lanes::Job
        STEPS = %w{clients projects invoices time_entries}

        attr_reader :fb
        def fetch_each(reqtype)
            Enumerator.new{ | enum |
                page = last_page = 1
                while page <= last_page
                    resp = fb.__send__(reqtype).list(per_page: 25, page: page)
                    data = resp[reqtype.pluralize]
                    last_page = data['pages'].to_i
                    page += 1
                    Array.wrap(data[reqtype]).each{|record|
                        enum.yield record
                    }
                end
            }.lazy
        end

        def fetch_clients
            fetch_each('client').map do |c|
                c.slice(*%w{ client_id organization first_name last_name})
            end
        end

        def fetch_projects
            fetch_each('project').map do | prj |
                c.clice(%w{project_id name description})
            end
        end

        def fetch_invoices
            fetch_each('invoice').map do | inv |
                inv.slice(*%w{invoice_id client_id number amount po_number notes status})
            end
        end

        def fetch_time_entries
            fetch_each('time_entry').reject{ |entry| entry['billed'] == '1' }
                .map{ | entry |
                  entry.slice(*%w{ time_entry_id staff_id project_id hours date notes})
              }
        end


        def perform(account, token)
            @fb = ::FreshBooks::Client.new("#{account}.freshbooks.com", token)
            output = {}
            STEPS.each_with_index do | step, index |
                output[step] = self.send("fetch_#{step}")
                job_status.set_progress((index+1).to_f / STEPS.length)
                job_status.save(
                    progress: STEPS.slice(0,index),
                    output: output
                )
            end
            self
        end

        def self.from_request(req)
            fb = ::FreshBooks::Client.new("#{req['domain']}.freshbooks.com", req['api_key'])
            error = nil
            begin
                # make a test api call to validate authentication
                resp = fb.client.list(per_page: 1)
                error = resp['error']
            rescue SocketError
                error = 'Unable to resolve account'
            end
            if error
                return {success: false, data: {}, error: error}
            else
                job = Skr::Jobs::FreshBooksRetrieve.perform_later(account, token)
                return {
                    success: true, message: 'Job Created', data: {
                        job: Lanes::Job.status_for_id(job.job_id)
                    }
                }
            end

        end
    end

end
