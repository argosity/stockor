require 'skr/db/migration_helpers'

class CreateSkrGlTransactionDetails < ActiveRecord::Migration[4.2]

    def up
        execute <<-EOS
        create view #{skr_prefix}gl_transaction_details as
          select
            glt.id as gl_transaction_id,
            to_char(glt.created_at,'YYYY-MM-DD') as transaction_date,
            pr.period as accounting_period,
            pr.year as accounting_year,
            ( select array_agg(account_number) from
              skr_gl_postings where gl_transaction_id=glt.id ) as account_numbers,
            ( select array_to_json(array_agg(row_to_json(postings))) from (
                select account_number, amount
                from skr_gl_postings
                where gl_transaction_id=glt.id and is_debit='t')
              postings) as debit_details,
            ( select array_to_json(array_agg(row_to_json(postings))) from (
                select account_number, amount
                from skr_gl_postings
                where gl_transaction_id=glt.id and is_debit='f')
              postings) as credit_details
         from #{skr_prefix}gl_transactions glt
           join #{skr_prefix}gl_periods pr on pr.id = glt.period_id

        EOS
    end

    def down
        execute "drop view #{skr_prefix}gl_transaction_details"
    end

end
