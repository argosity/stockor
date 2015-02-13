describe "Skr.Models.GlAccount", ->

    it "can be instantiated", ->
        model = new Skr.Models.GlAccount()
        expect(model).toEqual(jasmine.any(Skr.Models.GlAccount))
