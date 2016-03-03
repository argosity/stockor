class Skr.Components.SkuFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model.isRequired
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'SKU', name: 'code'

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

    render: ->
        props = _.extend( {}, @props )
        if @props.selectField
            <LC.SelectField labelField="code" displayFallback={@model.sku_code} {...props} />
        else
            <LC.RecordFinder commands={@props.commands} query={@query} {...props} />
