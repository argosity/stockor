module StockorSaas

    # All models in StockorSaas will inherit from
    # this common base class.
    class Model < Lanes::Model

        self.abstract_class = true

    end

    autoload :Tenant, "stockor-saas/models/tenant"
end
