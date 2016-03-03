class Skr.Components.GlAccountChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model

        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Account', name: 'gl_account'

    render: ->
        props = _.clone(@props)
        <LC.SelectField
            queryModel={Skr.Models.GlAccount}
            choices={Skr.Models.GlAccount.all.models}
            labelField="combined_name"
            model={@props.model}
            {...props}
        />
