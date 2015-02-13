describe "Skr.Models.Vendor", ->

    it "can be instantiated", ->
        model = new Skr.Models.Vendor()
        expect(model).toEqual(jasmine.any(Skr.Models.Vendor))
