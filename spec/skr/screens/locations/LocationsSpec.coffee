describe "Skr.Screens.Locations", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.Locations)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
