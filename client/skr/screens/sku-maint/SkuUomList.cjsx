class UomList extends Lanes.Models.State

    session:
        default:  'state'
        expanded: 'state'

    constructor: (@sku, expanded) ->
        super()
        @uoms       = @sku.uoms.clone()
        @default    = @uoms.findWhere(code: @sku.default_uom_code)
        @expanded = expanded or @uoms.first()

    save: ->
        @sku.associations.replace(@sku, 'uoms', @uoms)
        @sku.default_uom_code = @default.code

    add: ->
        @uoms.add({})
        @default = @uoms.first() if @uoms.length is 1
        @trigger('change', @uoms)

    map: (fn) -> @uoms.map(fn)

    isDefault: (uom) ->
        uom is @default

    setDefault: (uom) ->
        @trigger('change')
        @default = uom


class UomEdit extends Lanes.React.Component

    propTypes:
        list: React.PropTypes.instanceOf(UomList).isRequired
        uom:  React.PropTypes.instanceOf(Skr.Models.Uom).isRequired

    modelBindings:
        list: 'props'
        uom:  'props'

    onHeaderClick: (ev) ->
        return if ev.target.tagName is 'I'
        @list.expanded = @uom

    onCheckboxChange: (ev) ->
        return unless ev.target.tagName is 'I'
        @props.list.setDefault( @props.uom )

    render: ->
        header =
            <div className="cursor-pointer" onClick={@onHeaderClick}>
                <LC.Icon type="" />{@props.uom.combined}
                <span className='pull-right'>
                    <Skr.Components.Currency amount={@props.uom.price} />
                    <LC.Icon
                        style={marginLeft: '0.5em'}
                        onClick={@onCheckboxChange}
                        type={if @props.list.isDefault(@props.uom) then 'check-square-o' else 'square-o'} />
                </span>
            </div>

        <BS.Panel ref="panel" collapsible
            expanded={@list.expanded is @uom} header={header}>
            <BS.Row>
                <LC.Input type="text"  label='Code'
                    name='code' model={@props.uom} xs=4 />
                <LC.NumberInput type="number" label='Size' name='size' format='#,###'
                    model={@props.uom} xs=3 />
                <LC.NumberInput type="text"  label='Price' name='price'
                    model={@props.uom} xs=5 />
            </BS.Row>
        </BS.Panel>


class EditBody extends Lanes.React.Component

    propTypes:
        selected: React.PropTypes.instanceOf(Skr.Models.Uom)
        uoms: Lanes.PropTypes.Collection.isRequired

    modelBindings:
        uoms: 'props'

    add: ->
        @props.uoms.add()

    render: ->
        <BS.Accordion>
            <div className="sku-uom-edit">
                {@props.uoms.map (uom) =>
                    <UomEdit key={uom.cid} list={@props.uoms} uom={uom} />}
            </div>
        </BS.Accordion>

class UOMToken extends Lanes.React.BaseComponent

    propTypes:
        uom: React.PropTypes.instanceOf(Skr.Models.Uom)

    onClick: (ev) ->
        ev.preventDefault()
        @props.onEdit(@props.uom)

    render: ->
        <li onClick={@onClick} className="cursor-pointer">
            {@props.uom.combined}
            <Skr.Components.Currency
                style={marginLeft: '0.5rem'}
                amount={@props.uom.price} />
        </li>

class Skr.Screens.SkuMaint.SkuUomList extends Lanes.React.Component

    mixins: [
        LC.Form.FieldMixin
    ]

    getInitialState: ->
        editing: false

    onEdit: (selected = @model.uoms.first()) ->
        @setState
            editing: new UomList(@model)
            selected: selected

    onAdd: ->
        @refs.body.add()

    onOk: ->
        @state.editing.save()
        @setState(editing: false)

    onCancel: ->
        @setState(editing: false)

    renderEditingPopup: ->
        return <span /> unless @state.editing
        header =
            <div>
                <span>UOMs</span>
                <LC.Icon type="plus" className="pull-right" onClick={@onAdd} />
            </div>

        <BS.Popover
            ref="popover"
            className='sm'
            id='sku-edit-uoms'
            title={header} placement='left'>

                <div className={'clearfix'}>
                    <EditBody ref='body' uoms={@state.editing} selected={@state.selected} />
                    <div className='pull-right'>
                        <BS.Button onClick={@onCancel}>
                            Cancel
                        </BS.Button>
                        <BS.Button style={marginLeft: 10} bsStyle='primary' onClick={@onOk}>
                            OK
                        </BS.Button>
                    </div>
                </div>
        </BS.Popover>

    renderDisplay: ->
        value = @model.uoms.map (uom) ->
            uom.combined
        <span>{value.join(', ')}</span>

    renderEdit: (props) ->
        classNames = _.classnames('sku-uom-list', props.className)

        <div className={classNames}>
            <ul className="form-control">
            {@model.uoms.map (uom) =>
                <UOMToken key={uom.cid} uom=uom onEdit={@onEdit} />}
            </ul>
            <span className="input-group-btn">

                <BS.OverlayTrigger
                    classNames={classNames}
                    trigger="click"
                    ref="overlay"
                    rootClose
                    arrowOffsetTop={'130px'}
                    container={@}
                    show={@state.editing}
                    onExit={@onCancel}
                    placement="left"
                    overlay={@renderEditingPopup()}>

                    <BS.Button ref="addButton" onClick={ =>
                        @onEdit(@model.uoms.first())}
                    >
                        <LC.Icon type="gear" />
                    </BS.Button>
                </BS.OverlayTrigger>
            </span>
        </div>
