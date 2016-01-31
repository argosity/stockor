describe "Skr.Screens.FreshBooksImport", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.FreshBooksImport)
        expect(screen.getDOMNode().textContent).toMatch("Hello")
