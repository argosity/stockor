require_relative 'test_helper'

class InvLineTest < Skr::TestCase

    def test_inventory_adjusting
        inv = Invoice.new( customer: skr_customers(:argosity) )
        sl = skr_sku_locs(:stringdefault)
        inv.lines.build({
                :sku_loc => sl, :qty => 2
            })
        assert_difference ->{ sl.reload.qty }, -2 do
            assert_difference ->{ sl.reload.mac }, 0, "MAC was adjusted by invoice?" do
                assert_saves inv
            end
        end
    end

    def test_setting_price
        price = BigDecimal.new('112.54')
        inv = Invoice.new( location: skr_locations(:default), customer: skr_customers( :bigco ) )
        inv.lines.build(
            sku_loc: skr_sku_locs(:hatdefault),
            qty: 2,
            price: price
        )
        assert_saves inv
        line = inv.lines(true).first
        assert_equal price, line.price
        assert_equal price*2, line.extended_price
    end

    def test_no_updates
        inv = Invoice.new( customer: skr_customers( :argosity ) )
        inv.lines.build( sku_loc: skr_sku_locs(:hatdefault), qty: 1 )
        assert inv.save
        assert_raises(  ActiveRecord::ReadOnlyRecord ){ inv.lines.first.destroy }
    end

    def test_gl_posting
        inv = Invoice.new( customer: skr_customers(:argosity) )
        inv.lines.build({  :sku_loc => skr_sku_locs( :hatdefault ),    :qty => 1 }) # price is 3.11 from UOM
        inv.lines.build({  :sku_loc => skr_sku_locs( :stringdefault ), :qty => 2, price: 1.8 })
        inv.lines.build({  :sku_loc => skr_sku_locs( :glovedefault ),  :qty => 4, price: 2.1 })
        gl = skr_gl_accounts(:inventory)

        assert_difference ->{ GlPosting.count }, 2 do
            assert_difference ->{ gl.trial_balance }, -15.11 do
                assert_saves inv
            end
        end
    end

    def test_creating_with_sku
        inv = Invoice.new( customer: skr_customers(:argosity) )
        inv.lines.build({ sku: Sku.find_by_code('GLOVE'), qty: 1, price: 8.27 })
        assert_saves inv
    end
end
