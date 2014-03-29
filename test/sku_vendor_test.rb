require_relative 'test_helper'

class SkuVendorTest < Skr::TestCase

    def test_associations
        sv = skr_sku_vendors(:hat_bigco)
        assert_equal sv.vendor, skr_vendors(:bigco)
        assert_equal sv.sku,    skr_skus(:hat)
        skr_skus(:hat).sku_vendors.where( part_code: sv.part_code ).first.must_equal sv
        skr_vendors(:bigco).sku_vendors.where( vendor_id: sv.vendor, part_code: sv.part_code ).first.must_equal sv
    end

end
