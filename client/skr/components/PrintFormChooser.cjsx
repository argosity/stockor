class Skr.Components.PrintFormChooser extends Lanes.React.Component

    mixins: [ Lanes.Components.Form.FieldMixin ]

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


    renderEdit: (props) ->

        choices = @props.choices || @props.model.constructor.Templates
        value = @props.value or @props.model[@props.name]

        <Lanes.Vendor.ReactWidgets.DropdownList
            data={choices}
            value={value}
            onChange={@onChange}
        />
