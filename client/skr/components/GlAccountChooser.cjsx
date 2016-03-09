class Skr.Components.GlAccountChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model

        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Account', name: 'gl_account'

    dataObjects:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions
                src: Skr.Models.GlAccount.all, fields: [
                    {id:'id', visible: false}
                    {id: 'number', fixedWidth: 130 }
                    'name', 'description'
                ]
            })

    render: ->
        props = _.clone(@props)

        if props.finderField
            <LC.RecordFinder ref="finder"
                commands={@props.commands}
                query={@query}
                {...props} />
        else
            <LC.SelectField
                queryModel={Skr.Models.GlAccount}
                choices={Skr.Models.GlAccount.all.models}
                labelField="combined_name"
                model={@props.model}
                {...props}
            />
