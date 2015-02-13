describe "Skr.Views.Address", ->

    it "can be instantiated", ->
        view = new Skr.Views.Address()
        expect(view).toEqual(jasmine.any(Skr.Views.Address));
