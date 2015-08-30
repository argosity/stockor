describe "Skr.Models.SoLine", ->

    it "can sets properties from the uom", ->
        model = new Skr.Models.SoLine()
        model.uom = new Skr.Models.Uom(size: 10, code: 'CS')
        expect(model.uom_size).toEqual(10)
        expect(model.uom_code).toEqual('CS')
