require_relative 'spec_helper'

class TenantSpec < StockorSaas::TestCase

    it "can be instantiated" do
        model = Tenant.new
        model.must_be_instance_of(Tenant)
    end

end
