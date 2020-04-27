describe "StockorSaas.Models.Tenant", ->

    it "can be instantiated", ->
        model = new StockorSaas.Models.Tenant()
        expect(model).toEqual(jasmine.any(StockorSaas.Models.Tenant))
