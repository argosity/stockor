describe "Skr.Models.Customer", ->

    beforeEach ->
        Lanes.Test.ModelSaver.setUser('admin')

    it "sends failure messages when code isn't set", (done) ->
        model = new Skr.Models.Customer()
        Lanes.Test.ModelSaver.perform(model, done).then (save) ->
            expect(model.errors?.code).toContain("blank")

    it "saves when fields are set", (done) ->
        model = new Skr.Models.Customer(
            code: "SPECTEST", name: "A Spec Test Customer"
            terms: {code: 'SPECTESTER'}
            billing_address:  { name: "Billing Address" }
            shipping_address: { name: "Shipping Address" }
        )

        Lanes.Test.ModelSaver.perform(model, done).then (save) ->
            expect(model.errors).toBeUndefined()
