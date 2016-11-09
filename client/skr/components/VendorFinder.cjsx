class Skr.Components.VendorFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model.isRequired
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, name: 'vendor', label: 'Vendor Code'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                title: 'Vendors'
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.Vendor, fields: [
                    {id:'id', visible: false}
                    'code', 'name',
                    { id: 'notes', flex: 2}

                ]
            })

    render: ->
        props = _.omit(@props, 'selectField')

        if @props.selectField
            <LC.SelectField sm=2
                label="Vendor"
                name="vendor"
                labelField="code"
                model={@props.model}
                {...props}
            />
        else
            <LC.RecordFinder sm=3
                model={@props.model}
                name='vendor'
                commands={@state.commands}
                query={@query}
                {...props}
            />
