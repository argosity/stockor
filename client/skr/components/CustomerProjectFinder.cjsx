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
                    with: ['with_details']
                title: 'Customer Project'
                src: Skr.Models.CustomerProject, fields: [
                    { id:'id', visible: false     }
                    { id: 'code', fixedWidth: 120 }
                    { id: 'po_num', flex: 1       }
                    { id: 'description', flex: 2  }
                    { id: 'customer_code', fixedWidth: 140 }
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
