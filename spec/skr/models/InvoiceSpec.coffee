describe "Skr.Models.Invoice", ->

    it "can be instantiated", ->
        model = new Skr.Models.Invoice()
        expect(model).toEqual(jasmine.any(Skr.Models.Invoice))
