require_relative '../spec_helper'

class ExpenseEntrySpec < Skr::TestCase

    it "can be saved" do
        model = ExpenseEntry.new(
            name: 'Food Inc'
        )
        model.categories.build({
            amount: 101.42,
            category: skr_expense_category(:food)
        })
        assert_saves model
    end

    it 'calulates amount from  categories' do
        entry = skr_expense_entries(:gas)
        assert_equal entry.amount.to_s,  '65.0'
    end

    it 'can join with details' do
        entries = ExpenseEntry.with_category_details.order('occured desc')
        details = entries.map(&:category_list)

        assert_equal(details[0].first['amount'], 833.88)
        assert_equal(details[0].first['balance'], 886.88)

        assert_equal(details[2].first['balance'], 12.0)
    end

    it "can query details with a category id" do
        food = skr_expense_category(:food)
        entries = ExpenseEntry.with_category_details(food.id)
        assert_equal(entries.length, 1)
    end

end
