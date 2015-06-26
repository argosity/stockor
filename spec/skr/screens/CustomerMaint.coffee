#= require skr/screens/customer-maint

describe "CustomerMaint Screen Suite", ->

    xit "can be instantiated", ->
        view = new Skr.Screens.CustomerMaint()
        expect(view).toEqual(jasmine.any(Skr.Screens.CustomerMaint));
