describe "Skr.Models.Event", ->

    it "can be instantiated", ->
        model = new Skr.Models.Event()
        expect(model).toEqual(jasmine.any(Skr.Models.Event))
