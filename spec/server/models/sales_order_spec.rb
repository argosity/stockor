require_relative '../spec_helper'

class SalesOrderSpec < Skr::TestCase


    it "can be saved" do
        user = Lanes::User.find_by(login:'admin')
        model = SalesOrder.from_attribute_data({
                    terms_id: skr_payment_term(:cash).id,
                    location_id: skr_location(:default).id,
                    customer_id: skr_customer(:billy).id,
                    billing_address: {
                        name: "Billy"
                    },
                    shipping_address:{
                        name: "Billy"
                    }
                }, user)
        assert model.save
    end

    it 'queries using view helper scopes' do
        tiny = skr_sales_order(:tiny)
        assert_equal Skr::SalesOrder.with_sku_id(skr_sku(:yarn).id).pluck(:id), [tiny.id]
        attrs = Skr::SalesOrder.with_details.where(id: tiny.id).first.attributes
        assert_equal( attrs.slice('customer_code', 'customer_name', 'bill_addr_name', 'invoice_total', 'order_total'), {
                         "customer_code"  => "GOAT",
                         "customer_name"  => "Billy Goat Gruff",
                         "bill_addr_name" => "Hansel and Gretel",
                         "order_total"    => BigDecimal.new('115.48')
        })
    end

end
