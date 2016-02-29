SHARED_COLLECTION = new Skr.Models.PaymentTerm.Collection


class Skr.Components.TermsChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired
        label: React.PropTypes.string
        name:  React.PropTypes.string
        useFinder: React.PropTypes.bool

    getDefaultProps: ->
        label: 'Payment Terms', name: 'terms'

    componentWillMount: ->
        SHARED_COLLECTION.ensureLoaded()

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions
                src: Skr.Models.PaymentTerm, fields: [
                    { id:'id', visible: false}
                    { id: 'code', fixedWidth: 130 },
                    'description',
                    { id: 'days', fixedWidth: 80 }
                    { id: 'discount_days', label: 'Disc Days', fixedWidth: 80 }
                    { id: 'discount_amount', label: 'Disc Amt', fixedWidth: 80 }

                ]
            })

    render: ->
        if @props.useFinder
            <LC.RecordFinder ref="finder"
                commands={@props.commands} query={@query}
                {...@props} />
        else
            <LC.SelectField sm=3
                choices={SHARED_COLLECTION.models}
                labelField="code"
                {...@props}
                fetchWhenOpen={false}
                collection={SHARED_COLLECTION}
                model={@props.model} />
