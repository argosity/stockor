require_relative 'test_helper'

class VendorTest < Skr::TestCase

    def setup
        @vendor = Vendor.new({
            code: 'TEST',
            name: 'Mr Test Co',
            billing_address: skr_addresses(:bigco),
            shipping_address: skr_addresses(:bigco),
            terms: skr_payment_terms(:net30)
          })
    end

    def test_saving
        assert @vendor.save
    end

    def test_it_sets_gl
        assert @vendor.save
        assert_equal '2200', @vendor.gl_payables_account.number
    end

    def test_creating
        vendor = Vendor.find_by_code "BIGCO"
        po = PurchaseOrder.new( vendor: vendor )
        Sku.where( code: ['HAT','STRING'] ).each do | sku |
            po.lines.build(
              sku_vendor: sku.sku_vendors.for_vendor( vendor )
            )
        end
        po.save

    end
end
