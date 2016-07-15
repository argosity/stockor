class Skr.Components.TermsChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model.isRequired
        label: React.PropTypes.string
        name:  React.PropTypes.string
        useFinder: React.PropTypes.bool

    getDefaultProps: ->
        label: 'Payment Terms', name: 'terms'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
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
                collection={Skr.Models.PaymentTerm.all}
                commands={@props.commands}
                query={@query}
                {...@props} />
        else
            <LC.SelectField sm=3
                choices={Skr.Models.PaymentTerm.all.models}
                labelField="code"
                {...@props}
                fetchWhenOpen={false}
                model={@props.model} />
