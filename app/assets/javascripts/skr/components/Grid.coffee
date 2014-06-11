# DataTables class modifications
Skr.u.extend( Skr.$.fn.dataTableExt.oStdClasses,{
    sTable: "table table-striped"
	sWrapper: "dataTables_wrapper form-inline"
	sFilterInput: "form-control input-sm"
	sLengthSelect: "form-control input-sm"
})


class Skr.Component.Grid extends Skr.Component.Base
    events:
        'processing.dt': 'gridProcessing'
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

    gridProcessing: (dt,settings,working)->
        msg = this.$('.DTS_Loading')
        msg.toggle(working,true)
        # if working
        #     msg.spin('small',{left:'20%'})
        # else
        #     msg.spin(false)

    defineColumn: (column)->
        column = { field: column } if Skr.u.isString(column)
        Skr.u.defaults(column, {
            title: Skr.u.titleize(column.field)
        })

    delayedWidthReset: ->
        Skr.u.delay( =>
            @dt_api.columns.adjust()
        , 500 )

    render: ->
        super
        this.dataTable=this.$('table').dataTable(
            deferRender: true
            scrollY: "300px"
            serverSide: true
            oClasses: ['table', 'table-stiped', 'table-hover', 'table-condensed']
            bProcessing: true
            bDeferRender: true
            oScroller: { loadingIndicator: true }
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
        this.delayedWidthReset()
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
