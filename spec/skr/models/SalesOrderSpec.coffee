describe "Skr.Models.SalesOrder", ->

    it "must have a customer to save", (done)->
        model = new Skr.Models.SalesOrder()
        Lanes.Test.ModelSaver.perform(model, done).then (save)->
            expect(save.error).toHaveBeenCalled()
            expect(model.errors.customer).toContain("is not set")
