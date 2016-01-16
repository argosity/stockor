describe "Skr.Models.SalesOrder", ->


    it "it calculates total", ->
        so = new Skr.Models.SalesOrder()
        so.lines.add(sku_code: 'TEST', price: 2.12, qty:1)
        expect(so.total).toEqual(jasmine.any(_.bigDecimal))
        expect(so.total.toString()).toEqual('2.12')
        so.order_total = '1.42'
        expect(so.order_total.toString()).toEqual('1.42')
        expect(so.total.toString()).toEqual('1.42')
        expect(so.total).toEqual(jasmine.any(_.bigDecimal))

    it 'updates total and triggers change when lines change', ->
        so = new Skr.Models.SalesOrder()
        line = so.lines.add(sku_code: 'TEST', price: 2.12, qty:1)
        line.price = 3.42
        expect(so.total.toString()).toEqual('3.42')
        spy = jasmine.createSpy('on change')
        so.on('change', spy)
        line.price = 233.111
        expect(so.total.toString()).toEqual('233.111')
        expect(spy).toHaveBeenCalled()
