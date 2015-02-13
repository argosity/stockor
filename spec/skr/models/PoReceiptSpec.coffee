describe "Skr.Models.PoReceipt", ->

    it "can be instantiated", ->
        model = new Skr.Models.PoReceipt()
        expect(model).toEqual(jasmine.any(Skr.Models.PoReceipt))
