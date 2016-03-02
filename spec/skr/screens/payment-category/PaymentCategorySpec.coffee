describe "Skr.Screens.PaymentCategory", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.PaymentCategory)
        expect(_.dom(screen).text).toMatch("Hello")
