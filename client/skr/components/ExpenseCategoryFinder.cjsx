class Skr.Components.ExpenseCategoryFinder extends Lanes.React.Component

    propTypes:
        model:      Lanes.PropTypes.Model
        commands:   React.PropTypes.object
        autoFocus:  React.PropTypes.bool
        name:       React.PropTypes.string
        selectField:   React.PropTypes.bool

    getDefaultProps: ->
        autoFocus: false, label: 'Expense Category', name: 'code'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.ExpenseCategory, fields: [
                    {id:'id', visible: false}
                    {id: 'code', fixedWidth: 130 },
                    {id: 'name', flex: 1}
                ]
            })

    render: ->
        props = _.clone(@props)

        if props.selectField
            <LC.SelectField queryModel={Skr.Models.ExpenseCategory}
                labelField='code' sm=2 {...props} fetchOnSelect={false}
            />
        else
            <LC.RecordFinder ref="finder" sm=3 autoFocus
                commands={@props.commands}
                query={@query}
                {...props}
            />
