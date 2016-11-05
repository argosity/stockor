require_relative '../spec_helper'

class InvLineSpec < Skr::TestCase

    it "adjusts inventory" do
        inv  = skr_invoice(:tiny)
        yarn = skr_sku_loc(:yarn_def)
        line = inv.lines.build(:sku_loc  => yarn, qty: 2)
        assert_difference ->{ yarn.qty }, -2 do
            assert line.save, 'line failed to save'
        end
    end

    it "can set price" do
        tp = BigDecimal.new('112.54')
        inv = Invoice.new( location: skr_location(:default), customer: skr_customer( :hubbard ) )
        inv.lines.build(
            sku_loc: skr_sku_loc(:hat_def),
            qty: 1, price: tp
        )
        assert inv.save
        line = inv.lines(true).first
        assert_equal tp, line.price
        assert_equal tp, line.extended_price
    end

    it "adjusts so_line qty" do
        so = SalesOrder.new(customer: skr_customer(:billy))
        so_line = so.lines.build( sku_loc: skr_sku_loc(:hat_def), qty: 2)
        assert so.save
        assert_equal 2, so_line.qty_allocated
        inv = Invoice.new(sales_order: so)
        inv.lines.from_sales_order!
        assert inv.save
        assert_equal 2, inv.lines.first.qty
        assert_equal 2, so_line.reload.qty_invoiced
        assert_equal 0, so_line.qty_allocated
    end

    it "adjusts GL" do
        inv  = skr_invoice(:tiny)
        yarn = skr_sku_loc(:yarn_def)
        line = inv.lines.build(sku_loc: yarn, qty: 2)
        account = line.sku.gl_asset_account
        total = line.sku.uoms.default.price * line.qty
        assert_difference ->{ account.trial_balance }, (total * -1) do
            assert line.save, 'line failed to save'
        end
    end

   it "can be reversed" do
       inv = Invoice.new( location: skr_location(:default),
                          customer: skr_customer(:hubbard) )
        line = inv.lines.build( sku_loc: skr_sku_loc(:hat_def), qty: 2, price: 10.0 )
        total = line.total # sku.uoms.default.price * line.qty

        account = line.sku.gl_asset_account
        assert_difference ->{ account.trial_balance }, (total * -1) do
             assert inv.save, 'invoice failed to save'
        end
        assert_difference ->{ account.trial_balance }, BigDecimal.new('0.44') do
            line.price -= BigDecimal.new('0.22')
            assert line.save, 'failed to update inv line'
        end
        assert_difference ->{ account.trial_balance }, line.price do
            line.qty -= 1
            assert line.save, 'failed to update inv line'
        end
    end

   it 'cannot be deleted' do
       line = skr_inv_line(:tiny_hat)
       line.destroy
       assert line.errors.any?
       assert_raise ActiveRecord::RecordNotFound do
           line.reload
       end
   end

   it 'sets position when set from attributes' do
       inv = Invoice.new( location: skr_location(:default),
                          customer: skr_customer( :hubbard ),
                          lines_attributes: [
                              {sku_loc_id: skr_sku_loc(:hat_def).id,   qty: 1, price: 0.22},
                              {sku_loc_id: skr_sku_loc(:glove_def).id, qty: 2, price: 1.5},
                              {sku_loc_id: skr_sku_loc(:misc_def).id,  qty: 3, price: 2.5}
                          ])
        assert inv.save, 'invoice failed to save'
        inv.lines.pluck(:qty, :position).each do |qty, position|
            assert_equal(qty.to_i, position, "Line #{qty} does not equal position")
        end
   end

end
