KEY = 'SALES-HISTORY'

Skr.Api.Models.SalesHistory = {

    _encode: (sale) ->
        _.pick(sale, 'visible_id', 'hash_code', 'invoice_date', 'total')

    record: (sale) ->
        sales = @get()
        sales.push(@_encode(sale))
        localStorage.setItem(KEY, JSON.stringify({sales}) )

    get: (skuCode) ->
        sales = JSON.parse(localStorage.getItem(KEY))?.sales
        _.map sales, (sale) -> new Skr.Api.Models.Sale(sale)

}
