describe "Skr.Screens.BankMaint", ->

    it "can be rendered", ->
        screen = LT.renderComponent(Skr.Screens.BankMaint)
        expect(_.dom(screen).text).toMatch("Hello")
