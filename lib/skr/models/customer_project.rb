module Skr

    class CustomerProject < Model

        belongs_to :sku, export: true
        belongs_to :customer, export: true

        delegate_and_export :sku_code
        delegate_and_export :customer_code

        validates :sku, :customer, set: true

        has_many :time_entries, inverse_of: :customer_project, export: true

        scope :with_details, lambda { | *args |
            compose_query_using_detail_view(view: 'skr_customer_project_details')
        }, export: true

    end

end
