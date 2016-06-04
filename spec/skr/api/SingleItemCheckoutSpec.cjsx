##=require 'skr/api'

describe "Skr.Api.SingleItemCheckout", ->

    # beforeEach ->
    #     Lanes.Test.ModelSaver.setUser('admin')


    it "sends failure messages when code isn't set", (done) ->
        checkout = LT.renderComponent(Skr.Api.SingleItemCheckout, props: skuCode: 'HAT')
