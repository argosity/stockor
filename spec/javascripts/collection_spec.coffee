class TestModel extends Skr.Data.Model
    initialize: ->
        super(arguments)

class TestCollection extends Skr.Data.Collection
    model: TestModel
    initialize: ->
        super(arguments)

describe 'Collection', ->

    collection=null

    beforeEach ->
        collection=new TestCollection

     it "tracks loaded", ->
        expect(collection.isLoaded).toBeFalsy()

    it "Loads only once", ->
        spyOn(collection, 'fetch')
        collection.ensureLoaded()
        expect(collection.fetch).toHaveBeenCalled()

        collection.fetch.calls.reset()

        collection.isLoaded=true

        collection.ensureLoaded()
        expect(collection.fetch).not.toHaveBeenCalled()

    # it "uses supermodel", ->
    #     model = collection.add({ id: 234, color: 'red' })
    #     expect( TestModel.all().get(234) ).toBe( model )
