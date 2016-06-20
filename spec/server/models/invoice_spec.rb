require_relative '../spec_helper'

class InvoiceSpec < Skr::TestCase

    it 'disallows location changes' do
        inv = Skr::Invoice.new(sales_order: skr_sales_order(:tiny))
        assert inv.save, 'failed to save'
        inv.location = skr_location(:surplus)
        refute inv.save
        assert inv.errors[:location].any?
    end

    it 'cannot be posted to locked period' do
        GlPeriod.create(year: Time.now.year, period: Time.now.month, is_locked: true)
        inv = Skr::Invoice.new(customer: skr_customer(:billy))
        refute inv.save, 'invoice saved even though period was locked'
        assert inv.errors[:invoice_date].any?
    end


    it 'groups gl transactions together' do
        inv = Skr::Invoice.new(customer: skr_customer(:billy))
        inv.lines.build(sku_loc: skr_sku_loc(:glove_def), qty: 1, price: 10)
        inv.lines.build(sku_loc: skr_sku_loc(:hat_def),   qty: 1, price: 20)
        inv.lines.build(sku_loc: skr_sku_loc(:yarn_def),  qty: 1, price: 15)
        ar_account = skr_gl_account(:ar)
        invt_account = skr_gl_account(:inventory)
        assert_difference ->{ ar_account.trial_balance }, BigDecimal.new('45.0') do
            assert_difference ->{ invt_account.trial_balance }, BigDecimal.new('-45.0') do
                assert_difference ->{ SkuTran.count }, 3 do
                    assert_difference ->{ GlTransaction.count }, 1 do
                        assert inv.save, 'failed to save'
                    end
                end
            end
        end
    end

    it 'queries using view helper scopes' do
        tiny = skr_invoice(:tiny)
        tiny.payments.create!( amount: 10.10, bank_account: skr_bank_account(:checking) )
        assert_equal Skr::Invoice.with_sku_id(skr_sku(:yarn).id).pluck(:id), [tiny.id]
        attrs = Skr::Invoice.with_details.where(id: tiny.id).first.attributes
        assert_equal( attrs.slice('customer_code', 'customer_name', 'bill_addr_name',
                                  'invoice_total', 'sales_order_visible_id', 'invoice_total', 'amount_paid'), {
                         "customer_code"  => "GOAT",
                         "customer_name"  => "Billy Goat Gruff",
                         "bill_addr_name" => "Hansel and Gretel",
                         "sales_order_visible_id" => '1021',
                         'amount_paid' => BigDecimal.new('10.1'),
                         "invoice_total"  => BigDecimal.new('285.10')
        })
    end

end
