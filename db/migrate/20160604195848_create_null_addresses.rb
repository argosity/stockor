class CreateNullAddresses < ActiveRecord::Migration[4.2]
    def change
        %w{ customers vendors invoices sales_orders }.each do | rec |
            %w{ billing shipping }.each do | col |
                change_column_null "skr_#{rec}", "#{col}_address_id", :integer, true
            end
        end
    end
end
