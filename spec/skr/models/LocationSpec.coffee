describe "Skr.Models.Location", ->

    it "can be instantiated", ->
        model = new Skr.Models.Location()
        expect(model).toEqual(jasmine.any(Skr.Models.Location))
