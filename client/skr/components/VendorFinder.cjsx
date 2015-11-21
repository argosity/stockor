class Skr.Components.VendorFinder extends Lanes.React.Component

    propTypes:
        onModelSet: React.PropTypes.func
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        model:      Lanes.PropTypes.Model.isRequired
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false
        label: 'Vendor Code'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                title: 'Vendors'
                syncOptions:
                    include: ['billing_address', 'shipping_address']
                src: Skr.Models.Vendor, fields: [
                    {id:'id', visible: false}
                    'code', 'name',
                    { id: 'notes', flex: 2}

                ]
            })

    selectSetVendor: (model, cust) ->
        if @props.onModelSet
            @props.onModelSet(cust)
        else
            model.setVendor(cust)

    selectGetSelection: (model) ->
        if model.vendor_id and model.vendor_code
            {label: model.vendor_code, id: model.vendor_id}

    render: ->
        if @props.selectField
            <LC.SelectField sm=2
                label="Vendor"
                name="vendor"
                labelField="code"
                setSelection={@selectSetVendor}
                getSelection={@selectGetSelection}
                model={@props.model}
                {...@props} />
        else
            <LC.RecordFinder sm=3 autoFocus
                model={@props.model}
                name='vendor'
                commands={@state.commands}
                query={@query}
                {...@props} />
