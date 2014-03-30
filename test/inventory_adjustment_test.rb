require_relative 'test_helper'

class InventoryAdjustmentTest < Skr::TestCase

    def test_state_transitioning
        il = skr_sku_locs(:hatdefault)
        il.qty.must_equal 25
        ia = InventoryAdjustment.create!({ reason: skr_ia_reasons(:free),
            location: skr_locations(:default), description: 'A testing adjustment' })
        ia.lines.create!({ sku_loc: il,   uom_code: 'BX',  uom_size: 10,  qty: 3 })

        ia.state.must_equal 'pending'
        ia.lines.unapplied.size.must_equal 1
        ia.mark_applied!
        ia.state.must_equal 'applied'
        ia.lines.first.is_applied?.must_equal true
        il.reload
        il.qty.must_equal 55
        ia.lines.unapplied.size.must_equal 0
    end

    def test_apply_while_saving
        ia = InventoryAdjustment.create!({
                "reason_id" => skr_ia_reasons(:free).id,  "description"=>"A Groovy Adjustment",
                :state_event=>:mark_applied,
                "lines_attributes"=>[ {
                        "qty"=>10, "cost"=>3, "cost_was_set"=>true, "uom_code"=>"EA",
                        "uom_size"=>1, "sku_loc_id"=> skr_sku_locs(:hatdefault).id
                    } ],
                "location_id"=>skr_sku_locs(:hatdefault).location.id
            })
        refute ia.new_record?
        assert_equal :applied, ia.state_name
    end


    def test_gl_postings
        ia = InventoryAdjustment.new({
                reason: skr_ia_reasons(:free), "description"=>"This is going to cost us",
                state_event: :mark_applied, location: Location.default
              })

        assert_equal 25, skr_sku_locs( :hatdefault ).qty
        [ :hatdefault, :stringdefault ].each do | sl |
            ia.lines.build({
                sku_loc: skr_sku_locs( sl ),
                qty: 2, uom_code: 'CS', uom_size: 5,
              })
        end
        assert_difference('GlPosting.count', 2) do # would be 4, except it should compact
            assert ia.save, "failed to save adjustment"
        end
        assert_equal 35, skr_sku_locs( :hatdefault ).qty
        assert_equal 43, skr_sku_locs( :stringdefault ).qty
        assert_equal '2.12', skr_sku_locs( :stringdefault ).mac.to_s

        assert ia.transaction,"Missing GL Transaction?"

        # credits inventory
        assert_equal '27.6', ia.transaction.credits.first.amount.to_s
        assert_equal '110001', ia.transaction.credits.first.account_number

        # debits marketing (free reason code)
        assert_equal '-27.6', ia.transaction.debits.first.amount.to_s
        assert_equal '610001', ia.transaction.debits.first.account_number
    end

end
