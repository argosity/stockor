require 'skr/db/migration_helpers'

class CreateCustomerProjectDetailsViews < ActiveRecord::Migration

    def change
        execute "drop view if exists #{view}"
        execute <<-EOS
        create view #{view} as
          select
            cp.id as customer_project_id,
            c.code as customer_code,
            c.name as customer_description,
            s.code as sku_code,
            s.description as sku_description

          from skr_customer_projects cp
            join skr_skus s on s.id=cp.sku_id
            join skr_customers c on c.id=cp.customer_id
        EOS
    end

  private

    def view
        "#{skr_prefix}customer_project_details"
    end

end
