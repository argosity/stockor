module Skr

    # exposes sku records to the public via a CORS enabled endpoing, without authentication
    # Care is taken to only expose a few attributes of SKU's marked as "public"
    class Handlers::Skus < Lanes::API::ControllerBase

        def show
            query = build_query
            if params['for_event']
                event = Skr::Event.where(code: params['for_event']).first
                query = event ? query.where(id: event.sku_id) : Sku.none
            else
                query = query.where(is_public: true)
            end

            query = query.unscope(:select).select(Sku.public_fields)
            options = {methods: :price}

            options[:total_count] = query.dup.unscope(:select).count if should_include_total_count?
            if params[:id]
                query  = query.first!
            end
            std_api_reply(:retrieve, query, options)
        end

        def self.get
            lambda do
                'hiu'
            end
        end
    end
end
