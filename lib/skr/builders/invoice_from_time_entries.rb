module Skr
    module Builders
        class InvoiceFromTimeEntries

            def initialize(project_id, entry_ids, options = {})
                @project = CustomerProject.find(project_id)
                @entries = TimeEntry.find(entry_ids)
                @location = Location.default # should be set on project maybe?
                @sku_loc = @project.sku.sku_locs.find_by(location: @location)
                @options = options
            end

            def build_invoice
                invoice = Invoice.new(
                    customer_project: @project,
                    customer: @project.customer,
                    po_num: @options['po_num'] || @project.po_num,
                    notes: @options['notes']
                )
                @entries.each do | entry |
                    invoice.lines.build(
                        time_entry: entry,
                        sku_loc: @sku_loc,
                        price: @project.rates['hourly'],
                        description: entry.description,
                        qty: ((entry.end_at - entry.start_at) / 1.hour)
                    )
                end
                invoice
            end


            def self.handler
                lambda do
                    wrap_reply do
                        builder = InvoiceFromTimeEntries.new(
                            data['customer_project_id'], data['time_entry_ids'], data
                        )
                        invoice = builder.build_invoice
                        std_api_reply :create, { invoice: invoice }, success: invoice.save
                    end

                end
            end
        end
    end
end
