describe "Skr.Screens.SalesOrder", ->

    it "can be instantiated", ->
        view = new Skr.Screens.SalesOrder()
        expect(view).toEqual(jasmine.any(Skr.Screens.SalesOrder));
