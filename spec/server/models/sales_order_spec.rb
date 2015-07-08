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

end
