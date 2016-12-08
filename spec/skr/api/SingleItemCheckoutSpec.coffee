##= require skr/api/all

describe "Skr.SingleItemCheckout", ->

#    beforeEach (done) ->
    it "can be rendered", ->
        checkout = LT.renderComponent(Skr.SingleItemCheckout, skuCode: '11')

        console.log _.dom(checkout)
