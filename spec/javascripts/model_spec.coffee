class TestModel extends Skr.Data.Model

    initialize: (attributes={}, options={})->
        super(attributes, Skr.u.defaults( options, { name: 'Test' } ))


TestResponses = {
  test: {
    single: {
      status: 200,
      responseText: '{"data":{"color":"red", "foo":[{"type":"nearby","name":"Nearby"}]}}'
    }
  }
}


describe 'Model', ->
    model=null

    beforeEach ->
        model = new TestModel( id: 1, test: true, color: 'red' )
        jasmine.Ajax.install()

    it "can fetch model", ->
        model.fetch({
            include: 'foo'
        })
        request = jasmine.Ajax.requests.mostRecent()
        expect( request.url ).toEqual('test?i=foo')
        request.response(TestResponses.test.single)
        expect( model.get('color') ).toEqual("red")
        foo.bar()


        # console.log request
        # expect(request.data()).toEqual({latLng: ['40.019461, -105.273296']})


        # expect(request.method).toBe('GET')


        # # debugger
        # # console.log request
