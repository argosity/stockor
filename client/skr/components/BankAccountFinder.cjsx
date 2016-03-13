class Skr.Components.BankAccountFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Bank Account', name: 'code'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.BankAccount, fields: [
                    {id:'id', visible: false}
                    {id: 'code', fixedWidth: 130 },
                    {id: 'name', flex: 1}
                    {id: 'description', flex: 1.5}
                ]
            })

    render: ->
        props = _.clone(@props)

        if props.selectField
            <LC.SelectField queryModel={Skr.Models.BankAccount} sm=2 {...props} />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@props.commands}
                query={@query}
                {...props} />
