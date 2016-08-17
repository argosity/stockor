require_relative '../spec_helper'

class ExpenseCategorySpec < Skr::TestCase

    it "can be saved" do
        model = ExpenseCategory.new(
            code: 'FOO', name: 'Category Newer', is_active: true,
            gl_account: skr_gl_account(:misc_expense)
        )
        assert_saves model
    end

    it 'calculates balance' do
        assert_equal(skr_expense_category(:trans).balance.to_s, '886.88')
    end

end
