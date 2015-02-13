#= require skr/screens/base

describe "Base Screen Suite", ->

    it "can be instantiated", ->
        view = new Skr.Screens.Base()
        expect(view).toEqual(jasmine.any(Skr.Screens.Base));
