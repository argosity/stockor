describe "Skr.Models.PickTicket", ->

    it "can be instantiated", ->
        model = new Skr.Models.PickTicket()
        expect(model).toEqual(jasmine.any(Skr.Models.PickTicket))
