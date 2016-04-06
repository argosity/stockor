class Skr.Components.SkuLines extends Lanes.React.Component

    propTypes:
        lines:    Lanes.PropTypes.Collection.isRequired
        commands: React.PropTypes.object.isRequired
        location: Lanes.PropTypes.Model.isRequired
        queryBuilder: React.PropTypes.func.isRequired
        saveImmediately: React.PropTypes.func.isRequired

    getDefaultProps: ->
        queryBuilder: (a) -> a

    componentWillMount: ->
        @createQuery(@props.lines)

    componentWillReceiveProps: (nextProps) ->
        @createQuery(nextProps.lines) if nextProps.lines

    createQuery: (lines) ->
        @query = new Lanes.Models.Query(@props.queryBuilder({
            title: 'Lines'
            defaultSort: false
            src: lines,
            fields: [
                { id:'id', visible: false         }
                { id: 'sku_code', fixedWidth: 150 }
                { id: 'description', flex: 2      }
                {
                    id: 'uom', title: 'UOM', query: false, fixedWidth: 100,
                    format: (v, r, q)  -> v?.combined
                    sortBy: (a, b) ->
                        Lanes.u.comparator(a.uom_size, b.uom_size) or
                            Lanes.u.comparator(a.uom_code, b.uom_code)
                }
                { id: 'qty',   textAlign: 'center', fixedWidth: 100 }
                {
                    id: 'price', textAlign: 'right', fixedWidth: 130,
                    format: (v, r, q) -> v?.toFixed(2)
                }
            ]
        }))

    onSkuChange: (sku, options) ->
        options.model.set({sku})
        _.defer =>
            _.dom(@, 'input[name="qty"]').focusAndSelect() if @isMounted()

    editors: ->

        sku_code: ({model, props}) =>
            options = {
                with: {in_location: props.location.id}
                include: ['sku_locs', 'uoms']
            }
            <SC.SkuFinder
                writable selectField unstyled
                setSelection={@onSkuChange}
                name='sku' model={model}
                syncOptions={options}
            />

        uom: ({model}) ->
            <SC.UOMChooser writable unstyled model={model} />

    onSelectionChange:  (model) ->
        return Promise.resolve() unless model and not model.isNew() and @props.commands.isEditing()
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
            editorProps={location: @props.location, syncImmediatly: @props.saveImmediately}
            onSelectionChange={@onSelectionChange}
            allowDelete={true}
            allowCreate={true}
            editor={true}
        />
