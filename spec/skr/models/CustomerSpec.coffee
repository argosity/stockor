describe "Skr.Models.Customer", ->

    it "can be instantiated", ->
        model = new Skr.Models.Customer()
        expect(model).toEqual(jasmine.any(Skr.Models.Customer))
