require 'skr/db/migration_helpers'

class CreateGlAccountBalancesView < ActiveRecord::Migration[4.2]
    def up
        execute <<-EOS.squish
        create view #{skr_prefix}gl_account_balances as select
          gla.id as gl_account_id,
          right(glp.account_number,2) as branch_number,
          coalesce(sum(glp.amount), 0.00) as balance
        from skr_gl_accounts gla
        left join skr_gl_postings glp
          on left(glp.account_number, 4) = gla.number
        group by gla.id, branch_number order by number
        EOS
    end

    def down
        execute "drop view #{skr_prefix}gl_trial_balance"
    end
end
