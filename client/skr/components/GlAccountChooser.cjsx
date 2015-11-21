SHARED_COLLECTION = new Skr.Models.GlAccount.Collection

class Skr.Components.GlAccountChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired
        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Account', name: 'gl_account'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        props = _.clone(@props)
        <LC.SelectField
            {...props}
            collection={SHARED_COLLECTION}
            labelField="combined_name"
            fetchWhenOpen={false}
            model={@props.model} />
