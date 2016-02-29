describe "Skr.Models.Payment", ->

    it "can be instantiated", ->
        model = new Skr.Models.Payment()
        expect(model).toEqual(jasmine.any(Skr.Models.Payment))
