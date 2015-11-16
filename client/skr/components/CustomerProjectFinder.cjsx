class Skr.Components.CustomerProjectFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Project Code', name: 'code'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions:
                    include: [ 'customer', 'sku' ]
                src: Skr.Models.CustomerProject, fields: [
                    {id:'id', visible: false}
                    { id: 'code', fixedWidth: 120 }
                    { id: 'description', flex: 1 }
                    { id: 'notes', flex: 1.5 }
                ]
            })

    select: (model, proj) ->
        if @props.onModelSet
            @props.onModelSet(proj)
        else
            model.set(customer_project: proj)

    render: ->
        props = _.clone(@props)

        if props.selectField
            <LC.SelectField sm=2
                labelField="code"
                setSelection={@selectSetCustomer}
                getSelection={@selectGetSelection}
                {...props}
                model={@props.model}
            />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                query={@query}
                {...props}
                model={@props.model}
            />
