describe "Skr.Screens.PaymentTerms", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.PaymentTerms)
        expect(_.dom(screen).text).toMatch("Payment Terms")
