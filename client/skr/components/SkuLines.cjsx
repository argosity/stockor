class Skr.Components.SkuLines extends Lanes.React.Component

    propTypes:
        lines:    Lanes.PropTypes.Collection.isRequired
        commands: React.PropTypes.object.isRequired

    componentWillMount: ->
        @createQuery(@props.lines)

    componentWillReceiveProps: (nextProps) ->
        @createQuery(nextProps.lines) if nextProps.lines

    createQuery: (lines) ->
        @query = new Lanes.Models.Query
            title: 'Lines'
            src: lines, fields: [
                { id:'id', visible: false}
                { id: 'sku_code' }
                { id: 'description', flex: 2}
                {
                    id: 'uom', title: 'UOM', query: false,
                    format: (v, r, q)  -> v?.combined
                    sortBy: (a, b) ->
                        Lanes.u.comparator(a.uom_size, b.uom_size) or
                            Lanes.u.comparator(a.uom_code, b.uom_code)
                }
                { id: 'qty',   textAlign: 'center' }
                { id: 'price', textAlign: 'right', format: (v, r, q) -> v?.toFixed(2) }
            ]

    editors: ->
        sku_code: ({model}) ->
            <SC.SkuFinder model={model} selectField unstyled />

        uom: ({model}) ->
            <SC.UOMChooser model={model} unstyled />

    onSelectionChange:  (model) ->
        return unless model and @props.commands.isEditing()
        new _.Promise (res, rej) ->
            model.withAssociations([
                'sku_loc', 'sku', 'uom_choices'
            ]).then -> res(model)

    shouldSaveImmediatly: (model) ->
        not model.isNew()

    render: ->
        <LC.Grid query={@query}
            commands={@props.commands}
            autoLoadQuery={false}
            expandY={true}
            columEditors={@editors()}
            editorProps={syncImmediatly: @shouldSaveImmediatly}
            onSelectionChange={@onSelectionChange}
            height=200
            allowDelete={true}
            allowCreate={true}
            editor={true}
        />
