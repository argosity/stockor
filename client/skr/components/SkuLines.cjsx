class Skr.Components.SkuLines extends Lanes.React.Component

    propTypes:
        lines:    Lanes.PropTypes.Collection.isRequired
        commands: React.PropTypes.object.isRequired
        location: Lanes.PropTypes.Model.isRequired

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

    onSkuChange: (line, val, sel) ->
        line.set(sku: val)
        _.defer =>
            _.dom(@, 'input[name="qty"]').focusAndSelect() if @isMounted()

    editors: ->
        sku_code: ({model, props}) =>
            options = {
                with: {in_location: props.location.id}
                include: ['sku_locs', 'uoms']
            }
            <SC.SkuFinder
                setSelection={@onSkuChange}
                model={model}
                selectField unstyled syncOptions={options} />

        uom: ({model}) ->
            <SC.UOMChooser unstyled model={model} />

    onSelectionChange:  (model) ->
        return unless model and @props.commands.isEditing()
        new _.Promise (res, rej) ->
            model.withAssociations([
                'sku_loc', 'sku', 'uom_choices'
            ]).then -> res(model)

    render: ->
        <LC.Grid query={@query}
            ref='grid'
            commands={@props.commands}
            autoLoadQuery={false}
            expandY={true}
            columEditors={@editors()}
            editorProps={location: @props.location, syncImmediatly: @shouldSaveImmediatly}
            onSelectionChange={@onSelectionChange}
            height=200
            allowDelete={true}
            allowCreate={true}
            editor={true}
        />
