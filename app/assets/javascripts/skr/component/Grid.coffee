# DataTables class modifications
Skr.u.extend( Skr.$.fn.dataTableExt.oStdClasses,{
    sTable: "table table-striped"
	sWrapper: "dataTables_wrapper form-inline"
	sFilterInput: "form-control input-sm"
	sLengthSelect: "form-control input-sm"
})


class Skr.Component.Grid extends Skr.Component.Base
    events:
        'click tr': 'onRowClick'

    el: '<div class"skr-grid"><table cellspacing="0" width="100%"></table></div>'

    initialize: (options)->
        @columns = Skr.u.map(options.columns, this.defineColumn, this)
        @mode    = options.mode
        this.listenTo(Skr.View.InterfaceState,'change:screen_menu_size', this.delayedWidthReset )
        super

    isSingleSelect: ->
        @selectionMode && @selectionMode == 'single'

    _unselect: (row)->
        @fireEvent('unselect', @modelForRow(row) )
        row.removeClass('active')

    onRowClick: (ev)->
        tr = this.$(ev.target).closest('tr')
        if this.isSingleSelect()
            @_unselect(row) for row in this.$('tr .active')
        else
            if tr.hasClass('active')
                @_unselect(tr)
            else
                tr.addClass('active')
                @fireEvent('select', model ) if model = this.modelForRow(tr)

    modelForRow: (row)->
        data = this.dt_api.row(row).data()
        return null unless data
        attrs={ id: row.attr('id') }
        for field,i in @columns
            attrs[field.field] = data[i]
        new this.collection.prototype.model(attrs,ignoreUnsaved:true)

    fireEvent: (event,model)->
        this.$el.trigger(event,model)

    defineColumn: (column)->
        column = { field: column } if Skr.u.isString(column)
        Skr.u.defaults(column, {
            title: Skr.u.titleize(column.field)
        })

    delayedGridConfiguration: ->
        Skr.u.delay( =>
            @dt_api.columns.adjust()
        ,500 )

    calculateColumns: ->
        cols = []
        for index,column of this.columns
            index=parseInt(index)
            if column.align
                cols.push { className: column.align, "targets": [ index ] }
            else if 'n' == column.type
                cols.push { className: 'r', "targets": [ index ] }
        cols

    render: ->
        super
        responsiveHelper = undefined;
        breakpointDefinition = {
            tablet: 1024,
            phone : 480
        };

        this.dataTable=this.$('table').dataTable(
            deferRender: true
            scrollY: "300px"
            scrollX: true
            serverSide: true
            oClasses: ['table', 'table-stiped', 'table-hover', 'table-condensed']
            bProcessing: true
            bDeferRender: true
            oScroller: { loadingIndicator: true }
            columnDefs: this.calculateColumns()
            ajax:
                url: this.collection.prototype.url()
                data: (d)=>this.buildData(d)
                dataSrc: (d)->
                    d.recordsFiltered = d.recordsTotal = d.total
                    row.DT_RowId = row.shift() for row in d.data
                    d['data']
            dom: "rtiS"
            oScroller:
                rowHeight: 40
            columns: @columns
        )
        this.dt_api = this.dataTable.api()
        this.delayedGridConfiguration()
        this

    buildData: (d)->
        params = { o: {}, s: d.start, l: d.length||100, df:'array', f: ['id'].concat(Skr.u.pluck(@columns, 'field')) }
        if @query && ! Skr.u.isEmpty( query = @query.asParams() )
            params['q']=query
        for order in d.order
            column = @columns[order.column]
            params['o'][column.field] = order.dir
        params


    setQuery: (query)->
        @query=query
        @dt_api.ajax.reload()
