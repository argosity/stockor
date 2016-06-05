describe "Skr.Screens.SaleReport", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.SaleReport)
        expect(_.dom(screen).text).toMatch("Hello")
