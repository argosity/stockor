describe "Skr.Screens.Locations", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.Locations)
        expect(_.dom(screen).el.textContent).toMatch(/Code/)
