describe "Skr.Models.InventoryAdjustment", ->

    it "can be instantiated", ->
        model = new Skr.Models.InventoryAdjustment()
        expect(model).toEqual(jasmine.any(Skr.Models.InventoryAdjustment))
