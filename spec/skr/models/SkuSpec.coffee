describe "Skr.Models.Sku", ->

    it "can be instantiated", ->
        model = new Skr.Models.Sku()
        expect(model).toEqual(jasmine.any(Skr.Models.Sku))
