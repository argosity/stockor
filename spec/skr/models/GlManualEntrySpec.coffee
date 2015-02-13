describe "Skr.Models.GlManualEntry", ->

    it "can be instantiated", ->
        model = new Skr.Models.GlManualEntry()
        expect(model).toEqual(jasmine.any(Skr.Models.GlManualEntry))
