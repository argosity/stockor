describe "Skr.Screens.GlAccounts", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.GlAccounts)
        expect(_.dom(screen).text).toMatch("Hello")
