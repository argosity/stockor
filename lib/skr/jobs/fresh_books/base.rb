require 'ruby-freshbooks'

module Skr
    module Jobs
        module FreshBooks

            class Base < Lanes::Job
                STEPS = %w{staff clients projects time_entries invoices}

                attr_reader :fb
                def resp_data_for_req_type(type, resp)
                    if type == 'staff'
                        data = resp['staff_members']
                        data[type]=data.delete('member')
                        data
                    else
                        resp[type.pluralize]
                    end
                end

                def fetch_each(reqtype)
                    Enumerator.new { | enum |
                        page = last_page = 1
                        while page <= last_page
                            resp = fb.__send__(reqtype).list(per_page: 25, page: page)
                            data = resp_data_for_req_type(reqtype, resp)
                            last_page = data['pages'].to_i
                            page += 1
                            Array.wrap(data[reqtype]).each{|record|
                                enum.yield record
                            }
                        end
                    }
                end


                def process_each_type(account, token)
                    @fb = ::FreshBooks::Client.new("#{account}.freshbooks.com", token)
                    output = {}
                    @ignored_ids ||= {}
                    STEPS.each_with_index do | step, index |
                        type = step.singularize
                        output[step] = fetch_each( type ).map { | record |
                            send("process_#{type}", record)
                        }.reject(&:nil?)
                        yield output, index
                    end
                    output
                end

            end
        end
    end
end
