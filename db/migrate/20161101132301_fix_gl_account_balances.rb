require 'skr/db/migration_helpers'

class FixGlAccountBalances < ActiveRecord::Migration

    # skr_gl_account_balances

    def drop_n_create
        execute "drop view skr_gl_account_balances"
        execute <<-EOS.squish
        create view skr_gl_account_balances as select
          gla.id as gl_account_id,
          right(glp.account_number,2) as branch_number,
          coalesce(sum(glp.amount), 0.00) as balance
        from skr_gl_accounts gla
        left join skr_gl_postings glp
          on left(glp.account_number, 4) = gla.number
        group by gla.id, branch_number order by number;
        EOS
    end

    def up
        drop_n_create
    end

    def down
        drop_n_create
    end
end
