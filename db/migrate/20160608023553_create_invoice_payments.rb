class CreateInvoicePayments < ActiveRecord::Migration[4.2]
    def change
        add_column :skr_payments, :invoice_id, :integer
        add_column :skr_payments, :metadata,   :jsonb, default: {}
        remove_column :skr_invoices, :amount_paid,  :decimal, precision: 15, scale: 2
        change_column_null :skr_payments, :category_id, true
        change_column_null :skr_payments, :check_number, true
    end
end
