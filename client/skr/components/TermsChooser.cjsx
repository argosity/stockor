SHARED_COLLECTION = new Skr.Models.PaymentTerm.Collection

class Skr.Components.TermsChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired
        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Payment Terms', name: 'terms'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    render: ->
        <LC.SelectField sm=3
            labelField="code"
            {...@props}
            fetchWhenOpen={false}
            collection={SHARED_COLLECTION}
            model={@props.model} />
