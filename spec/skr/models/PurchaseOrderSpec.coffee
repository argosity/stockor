describe "Skr.Models.PurchaseOrder", ->

    it "can be instantiated", ->
        model = new Skr.Models.PurchaseOrder()
        expect(model).toEqual(jasmine.any(Skr.Models.PurchaseOrder))
