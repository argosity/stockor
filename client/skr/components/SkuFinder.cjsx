class Skr.Components.SkuFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model.isRequired
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false
        label: 'SKU'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions
                src: Skr.Models.Sku, fields: [
                    {id:'id', visible: false}
                    'code'
                    { id: 'description', flex: 2}
                ]
            })

    selectSetSKU: (model, cust) ->
        if @props.onModelSet
            @props.onModelSet(cust)
        else
            model.set(customer: cust)

    selectGetSKU: (model) ->
        if model.customer_id and model.customer_code
            {label: model.customer_code, id: model.customer_id}

    render: ->
        props = _.extend( { label: 'SKU', name: 'sku' }, @props )
        if @props.selectField
            <LC.SelectField labelField="code" displayFallback={@model.sku_code} {...props} />
        else
            <LC.RecordFinder commands={@props.commands} query={@query} {...props} />
