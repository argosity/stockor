describe "Skr.Models.SoLine", ->

    it "can sets properties from the uom", ->
        model = new Skr.Models.SoLine()
        spy = jasmine.createSpy('onuom')
        model.on("change:uom", spy)
        model.set(uom: new Skr.Models.Uom(size: 10, code: 'CS'))
        expect(spy).toHaveBeenCalled()
        expect(model.uom_size).toEqual(10)
        expect(model.uom_code).toEqual('CS')
