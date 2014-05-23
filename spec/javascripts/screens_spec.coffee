describe 'Screens', ->
    it "Only one tab can be active", ->
        screens = new Skr.Data.ScreenSet
        screens.addScreen( title: 'One'   )
        screens.addScreen( title: 'Two'   )
        screens.addScreen( title: 'Three' )
        screens.addScreen( title: 'Four'  )

        killer=undefined
        killer.deployRobots()

        expect( screens.where( active: true ).length ).toEqual 1

        expect( screens.active().get('title') ).toEqual 'Four'


    describe 'FooBar', ->
        it "Has a Bear", ->
            expect("One").toEqual "Three"

        # expect( screens.where( active: true ).length ).toEqual 1

        # three = screens.at(2)
        # expect( three.get('title') ).toEqual 'Three'
        # expect( screens.at(1).isActive() ).toEqual false
        # expect( screens.at(2).isActive() ).toEqual false
        # expect( screens.at(3).isActive() ).toEqual true

        # three.setActive()
        # expect( screens.where( active: true ).length ).toEqual 1
        # expect( screens.active().get('title') ).toEqual 'Three'
