module Skr

    # exposes sku records to the public via a CORS enabled endpoing, without authentication
    # Care is taken to only expose a few attributes of SKU's marked as "public"
    class Handlers::Skus < Lanes::API::ControllerBase

        def show
            query = build_query.where(
                is_public: true
            ).unscope(:select).select(:id, :code, :description, :default_uom_code)
            options = {methods: :price}

            #options = build_reply_options

#            options[:include] = include_associations.each_with_object({}) do |association, includes|

            # query   = add_modifiers_to_query(query)
            options[:total_count] = query.dup.unscope(:select).count if should_include_total_count?
            if params[:id]
                query  = query.first!
            end
            std_api_reply(:retrieve, query, options)

            # sku = Sku.where(code: params[:code]).first.pluck(:id, :code, :description)

            # std_api_reply(:get, sku, success: true )

        end

        def self.get
            lambda do
                'hiu'
            end
        end
    end
end
