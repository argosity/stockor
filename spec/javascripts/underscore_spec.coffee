describe 'Underscore', ->
    it "should have underscore", ->
        expect( Skr.u.min([1,2,0]) ).toEqual(0)
