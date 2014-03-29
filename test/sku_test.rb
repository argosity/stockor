require_relative 'test_helper'

class SkuTest < Skr::TestCase

    def test_locations
        sku = skr_skus(:string)
        assert_equal 2, sku.sku_locs.length
        assert sku.sku_locs.find_or_create_for( skr_locations(:surplus) )
        loc = skr_locations(:amazon)
        refute sku.sku_locs.where( location: loc ).first
        assert sku.sku_locs.find_or_create_for( loc )
    end

    def test_vendors
        sku = skr_skus(:glove)
        assert sku.sku_vendors.default
        assert_equal skr_sku_vendors(:glove_bigco), sku.sku_vendors.default
    end

    def test_uoms
        sku = skr_skus(:hat)
        assert sku.uoms.default
    end

    # def test_qty_details_view
    #     hat = Sku.where(code:'HAT').with_qty_details.first
    #     #with_qty_details
    # end

    # def test_auto_location_creation
    #     i=Sku.new({ :code=>'Test', :description=>'A Long Description' })
    #     i.sku_vendors.build({
    #             code: 'TESTHAT', vendor: vendors(:bigco),
    #             list_price: 0.42, cost: 0.34, uom_size: 1, uom_code: 'EA' })
    #     i.default_uom_code  = 'EA'
    #     i.locations.must_be_empty
    #     i.new_record?.must_equal true
    #     i.save!.must_equal true
    #     i.locations.wont_be_empty
    # end

    # def test_uoms
    # it "has_uoms" do
    #     skus('0838').uoms.must_include uoms('0838EA')
    # end

    # it "sanitizes nested locations" do
    #     data = { locations_attributes:[
    #                                    {id:1,sku_id:1,location_id:15,location_code:'DEFAULT',location_name:'Default',mac:nil,qty:0,
    #                                        red_rabbit: 'RED-RABBIT',
    #                                        created_at:'2011-11-29T11:23:18',updated_at:'2011-11-29T11:23:18'}
    #                                   ] }
    #     clean = Sku.api_sanitize_json( data )['locations_attributes']
    #     clean.first['red_rabbit'].must_be_nil
    # end

    # it "sanitizes location_code" do
    #     params = {
    #         id:skus('0838').id, code:'TEST',description:'A Testomg IOtem',list_price:0,does_track_inventory:true,
    #         default_vendor_id:vendors(:bigco).id, default_uom_code:'EA',created_at:nil,updated_at:nil,
    #             locations_attributes:[
    #                                   {id:sku_locs('0838default').id,sku_id:skus('0838').id,location_id:locations(:default).id,
    #                                       location_code:'DEFAULT',location_name:'Default',mac:nil,qty:0,
    #                                       gl_branch_code: '03', created_at:'2011-11-29T11:23:18',updated_at:'2011-11-29T11:23:18'}
    #                                  ],
    #             uoms_attributes:[
    #                              {id:uoms('0838CA').id, sku_id:skus('0838').id, code:'BOX',size:5,is_sellable:true,is_buyable:false,default_selling:true,
    #                                  created_at:'2011-11-26T13:02:23',updated_at:'2011-11-26T13:02:23'}
    #                             ]
    #         }
    #     il = Sku.api_sanitize_json( params )['locations_attributes'].first
    #     il['location_id'].must_equal sku_locs('0838default').location_id
    #     il['location_code'].must_be_nil
    # end

end
