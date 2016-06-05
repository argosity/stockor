class Skr.Components.CustomerFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model.isRequired
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Customer Code', name: 'customer'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.Customer, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 }, 'name', 'notes',
                    { id: 'open_balance', fixedWidth: 100, textAlign: 'right', format: (v) ->
                        if v then _.bigDecimal(v).toFixed(2) else '0.00'
                    }
                ]
            })

    render: ->
        props = _.clone(@props)
        if props.selectField
            <LC.SelectField labelField='code' sm=2 labelField="code" {...props} />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@props.commands}
                query={@query}
                {...props} />
