describe "Skr.Models.PaymentTerm", ->

    it "can be instantiated", ->
        model = new Skr.Models.PaymentTerm()
        expect(model).toEqual(jasmine.any(Skr.Models.PaymentTerm))
