describe "Skr.Models.TimeEntry", ->

    it "can be instantiated", ->
        model = new Skr.Models.TimeEntry()
        expect(model).toEqual(jasmine.any(Skr.Models.TimeEntry))
