describe "Skr.Screens.CustomerProjects", ->

    xit "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.CustomerProjects)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
