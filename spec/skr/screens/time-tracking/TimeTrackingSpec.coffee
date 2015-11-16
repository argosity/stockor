describe "Skr.Screens.TimeTracking", ->

    xit "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.TimeTracking)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
