class Skr.Components.GlAccountChooser extends Lanes.React.Component

    propTypes:
        model: Lanes.PropTypes.Model
        label: React.PropTypes.string
        name:  React.PropTypes.string

    getDefaultProps: ->
        label: 'Account', name: 'gl_account'

    modelBindings:
        query: ->
            new Lanes.Models.Query({
                syncOptions: @props.syncOptions, autoRetrieve: true
                src: Skr.Models.GlAccount.all, fields: [
                    {id:'id', visible: false}
                    {id: 'number', fixedWidth: 130 }
                    'name', 'description'
                ]
            })

    render: ->

        props = _.omit(@props, 'useFinder')

        if @props.useFinder
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
                filter='contains'
                {...props}
            />
