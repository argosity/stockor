describe "Skr.Screens.ExpenseEntry", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.ExpenseEntry)
        expect(_.dom(screen).text).toBeDefined()
