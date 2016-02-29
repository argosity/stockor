describe "Skr.Models.BankAccount", ->

    it "can be instantiated", ->
        model = new Skr.Models.BankAccount()
        expect(model).toEqual(jasmine.any(Skr.Models.BankAccount))
