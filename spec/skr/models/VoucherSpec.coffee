describe "Skr.Models.Voucher", ->

    it "can be instantiated", ->
        model = new Skr.Models.Voucher()
        expect(model).toEqual(jasmine.any(Skr.Models.Voucher))
