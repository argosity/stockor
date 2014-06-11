describe 'Screens', ->
    it "Only one tab can be active", ->
        screens = new Skr.Data.ScreenSet([],single_active_only:true)
        screens.addScreen( title: 'One'   )
        screens.addScreen( title: 'Two'   )
        screens.addScreen( title: 'Three' )
        screens.addScreen( title: 'Four'  )

        expect( screens.where( active: true ).length ).toEqual 1

        expect( screens.where( active: true ).length ).toEqual 1

        three = screens.at(2)
        expect( three.get('title') ).toEqual 'Three'
        expect( screens.at(1).isActive() ).toEqual false
        expect( screens.at(2).isActive() ).toEqual false
        expect( screens.at(3).isActive() ).toEqual true

        three.setActive()
        expect( screens.where( active: true ).length ).toEqual 1
        expect( screens.active().get('title') ).toEqual 'Three'
