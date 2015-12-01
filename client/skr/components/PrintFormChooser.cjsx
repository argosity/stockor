class Skr.Components.PrintFormChooser extends Lanes.React.Component

    propTypes:
        label: React.PropTypes.string.isRequired
        model: Lanes.PropTypes.Model.isRequired
        choices: React.PropTypes.array

    mixins: [
        Lanes.React.Mixins.ReadEditingState
    ]

    onChange: (val) ->
        if @props.onChange
            @props.onChange?(val, @props)
        else
            @props.model[@props.name] = val

    renderEdit: (value) ->
        choices = @props.choices || @props.model.constructor.Templates
        <Lanes.Vendor.ReactWidgets.DropdownList
            data={choices}
            value={value}
            onChange={@onChange}
        />

    renderValue: (value) ->
        value

    render: ->
        value = @props.value or @props.model[@props.name or 'form'] or 'default'
        props = _.omit(@props, 'choices', 'name')
        <LC.FormGroup editing={@isEditingRecord()}
            className="field" {...props}
        >
            {if @isEditingRecord() then @renderEdit(value) else @renderValue(value)}
        </LC.FormGroup>
