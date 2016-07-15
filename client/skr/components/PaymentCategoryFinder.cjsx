class Skr.Components.PaymentCategoryFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Payment Category', name: 'payment_category'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.PaymentCategory, fields: [
                    {id:'id',   visible: false}
                    {id:'gl_account_id', visible: false}
                    {id:'code', fixedWidth: 130 },
                    {id:'name', flex: 1}
                ]
            })

    render: ->
        props = _.clone(@props)

        if props.selectField
            <LC.SelectField queryModel={Skr.Models.PaymentCategory}
                labelField='code' sm=2 {...props} />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@props.commands}
                query={@query}
                {...props} />
