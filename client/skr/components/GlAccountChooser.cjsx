SHARED_COLLECTION = new Skr.Models.GlAccount.Collection([], comparator: 'number')

class Skr.Components.GlAccountChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model

        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Account', name: 'gl_account'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        props = _.clone(@props)
        <LC.SelectField
            queryModel={Skr.Models.GlAccount}
            choices={SHARED_COLLECTION.models}
            labelField="combined_name"
            model={@props.model}
            {...props}
        />
