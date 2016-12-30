describe "Skr.Screens.Events", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.Events)
        expect(_.dom(screen).text).toBeTruthy()
