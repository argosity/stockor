describe "Skr.Models.GlTransaction", ->

    it "can be instantiated", ->
        model = new Skr.Models.GlTransaction()
        expect(model).toEqual(jasmine.any(Skr.Models.GlTransaction))
