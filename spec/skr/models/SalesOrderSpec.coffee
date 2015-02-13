describe "Skr.Models.SalesOrder", ->

    it "can be instantiated", ->
        model = new Skr.Models.SalesOrder()
        expect(model).toEqual(jasmine.any(Skr.Models.SalesOrder))
