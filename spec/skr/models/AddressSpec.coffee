describe "Skr.Models.Address", ->

    it "can be instantiated", ->
        model = new Skr.Models.Address()
        expect(model).toEqual(jasmine.any(Skr.Models.Address))
