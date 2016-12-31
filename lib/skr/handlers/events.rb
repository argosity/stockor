module Skr

    # exposes an event record to the public via a CORS enabled endpoing,
    # without authentication
    # Care is taken to only expose a few attributes of SKU's marked as "public"
    class Handlers::Events < Lanes::API::ControllerBase

        def show
            event = build_query.includes(invoices: [:lines]).first
            json = event.as_json(methods: :qty_remaining).merge(
                sku: event.sku.public_data
            )
            std_api_reply(:retrieve, json)
        end

    end
end
