describe "Skr.Screens.TimeInvoicing", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.TimeInvoicing)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
