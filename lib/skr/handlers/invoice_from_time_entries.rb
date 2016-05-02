module Skr
    module Handlers
        class InvoiceFromTimeEntries
            include Lanes::API::FormattedReply

            def initialize(model, authentication, params, data)

                @options   = data
                @entry_ids = data['time_entry_ids']
                @project   = CustomerProject.find( data['customer_project_id'] )
                @location  = Location.default # should be set on project maybe?
                @sku_loc   = @project.sku.sku_locs.find_by(location: @location)
            end

            def perform_creation
                invoice = Invoice.new(
                    notes:    @options['notes'],
                    po_num:   @options['po_num'] || @project.po_num,
                    customer: @project.customer,
                    customer_project: @project
                )
                @entry_ids.each do | entry_id |
                    entry = TimeEntry.find(entry_id)
                    invoice.lines.build(
                        time_entry: entry,
                        sku_loc: @sku_loc,
                        price: @project.rates['hourly'],
                        description: entry.description,
                        qty: ((entry.end_at - entry.start_at) / 1.hour)
                    )
                end
                std_api_reply :create, { invoice: invoice }, success: invoice.save
            end

        end
    end
end
