class Skr.Components.PrintFormChooser extends Lanes.React.Component

    propTypes:
        label: React.PropTypes.string.isRequired
        model: Lanes.PropTypes.Model.isRequired
        choices: React.PropTypes.array

    getDefaultProps: ->
        name: 'form'

    onChange: (val) ->
        if @props.onChange
            @props.onChange?(val, @props)
        else
            @props.model[@props.name] = val

    renderValue: (value) ->
        value

    render: ->
        choices = @props.choices || @props.model.constructor.Templates
        value = @props.value or @props.model[@props.name]
        <LC.FieldWrapper {...@props} value={value}>
            <Lanes.Vendor.ReactWidgets.DropdownList
                data={choices}
                value={value}
                onChange={@onChange}
            />
        </LC.FieldWrapper>
