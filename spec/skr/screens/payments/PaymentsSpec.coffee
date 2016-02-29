describe "Skr.Screens.Payments", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.Payments)
        expect(_.dom(screen).text).toMatch("Hello")
