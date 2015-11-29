class Skr.Components.PrintFormChooser extends Lanes.React.Component

    propTypes:
        label: React.PropTypes.string
        model: Lanes.PropTypes.Model.isRequired

    mixins: [
        Lanes.React.Mixins.ReadEditingState
    ]

    onChange: ->
        (f) => @invoice.form = f

    renderEdit: (value) ->
        choices = @props.model.constructor.Templates
        <Lanes.Vendor.ReactWidgets.DropdownList
            data={choices}
            value={value}
            onChange={@onChange}
        />

    renderValue: (value) ->
        value

    render: ->
        value = @props.model[@props.name or 'form'] or 'default'
        props = _.omit(@props, 'choices', 'name')
        <LC.FormGroup editing={@isEditingRecord()}
            className="field" {...props}
        >
            {if @isEditingRecord() then @renderEdit(value) else @renderValue(value)}
        </LC.FormGroup>
