describe "Skr.Screens.Invoice", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.Invoice)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
