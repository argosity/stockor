describe "Skr.Models.Customer", ->

    it "can be instantiated", ->
        model = new Skr.Models.Customer()
        expect(model).toEqual(jasmine.any(Skr.Models.Customer))


    it "sends failure messages when code isn't set", (done)->
        model = new Skr.Models.Customer()
        Lanes.Testing.ModelSaver.perform(model, done).then (save)->
            expect(save.error).toHaveBeenCalled()
            expect(model.errors.code).toContain("blank")

    it "saves when fields are set", (done)->
        model = new Skr.Models.Customer(
            code: "SPECTEST", name: "A Spec Test Customer"
            billing_address:  { name: "Billing Address" }
            shipping_address: { name: "Shipping Address" }
        )
        Lanes.Testing.ModelSaver.perform(model, done).then (save)->
            expect(save.error).not.toHaveBeenCalled()
            expect(model.errors).toBeNull()


        # model.save().then( null, ->
        #
        #         done()
        # )

        # expect(success).not.toHaveBeenCalled()
        # expect(failure).toHaveBeenCalled()
        # console.log model.errors
        #

        #  ->
        #     expect(false).toBeTrue
        # ,  ->
        #     assert_equal 1, model.errors.length
        #     done()
