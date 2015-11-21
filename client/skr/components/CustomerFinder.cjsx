class Skr.Components.CustomerFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Customer Code', name: 'customer'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions
                src: Skr.Models.Customer, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 }, 'name', 'notes',
                    { id: 'open_balance', fixedWidth: 100, textAlign: 'right', format: (v) ->
                        if v then _.bigDecimal(v).toFixed(2) else '0.00'
                    }
                ]
            })

    selectSetCustomer: (model, cust) ->
        if @props.onModelSet
            @props.onModelSet(cust)
        else
            model.set(customer: cust)

    selectGetSelection: (model) ->
        if model.customer_id and model.customer_code
            {label: model.customer_code, id: model.customer_id}

    render: ->
        props = _.clone(@props)

        if props.selectField
            <LC.SelectField sm=2
                labelField="code"
                setSelection={@selectSetCustomer}
                getSelection={@selectGetSelection}
                {...props} />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@state.commands}
                query={@query}
                {...props} />
