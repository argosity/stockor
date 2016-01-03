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
        console.log @props.model.form, @props

        <LC.FieldWrapper {...@props} value={value}>

            <Lanes.Vendor.ReactWidgets.DropdownList
                data={choices}
                value={value}
                onChange={@onChange}
            />
        </LC.FieldWrapper>
        # value = @props.value or @props.model[@props.name]
        # props = _.omit(@props, 'choices', 'name')
        # <LC.FormGroup editing={@isEditingRecord()}
        #     className="field" {...props}
        # >
        #     {if @isEditingRecord() then @renderEdit(value) else @renderValue(value)}
        # </LC.FormGroup>
