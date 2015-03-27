describe "Skr.Screens.VendorMaint", ->

    it "can be instantiated", ->
        view = new Skr.Screens.VendorMaint()
        expect(view).toEqual(jasmine.any(Skr.Screens.VendorMaint));
