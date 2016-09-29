class TextCategory extends Lanes.React.Component
    modelBindings:
        category: 'props'

    render: ->
        code = @props.categories.get(@category.category_id).code
        <span className='pair'>
            {Lanes.u.format.currency(@category.amount)} {code}
        </span>


class Category extends Lanes.React.Component

    modelBindings:
        category: 'props'

    delete: ->
        @props.onEntryDestroy(@props.category)

    render: ->
        <div className="category">
            <SC.ExpenseCategoryFinder selectField
                choices={@props.categories.models} fetchOnSelect={false}
                model={@category} name='category' />
            <LC.NumberInput name='amount' model={@category} align="right" />
            <BS.Button className="delete"
                onClick={@delete}
            >
                <LC.Icon type="trash-o" lg />
            </BS.Button>

        </div>

class Skr.Screens.ExpenseEntry.Categories extends Lanes.React.Component

    modelBindings:
        entry: 'props'
        categories: 'props'
        entryCategories: ->
            if @props.entry.categories.isEmpty()
                @props.entry.categories.add({})
            @props.entry.categories

    addCategory: ->
        @entry.categories.add({})
        @setState(overlayShown: true)
        _.defer =>
            _.dom(@, '.popover-content .category:last-child .select input').focus()

    onMultiClick: ->
        @setState(overlayShown: true)

    getPopOverTarget: ->
        _.dom(@refs.overlayTarget).el

    onEntryDestroy: (cat) ->
        @setState(overlayShown: false)
        @props.entry.categories.remove(cat)

    renderMultiple: ->

        entries = @entry.categories.map (category) =>
            <Category key={category.cid} category={category}
                onEntryDestroy={@onEntryDestroy}
                categories={@props.categories} />
        msg =
            @entry.categories.map (expcat) =>
                category = @categories.get( expcat.category_id )
                return null unless category
                <TextCategory key={expcat.cid} category={expcat} categories={@categories} />

        <BS.Col sm=12 className="multiple">
            <BS.FormGroup>
                <BS.ControlLabel>Categories</BS.ControlLabel>
                <div className='controls'>
                    <BS.FormControl.Static onClick={@onMultiClick}>{msg}</BS.FormControl.Static>
                    <LC.IconButton icon="edit" className="view" ref="overlayTarget"
                        onClick={=> @setState(overlayShown: true)}
                    />
                    <BS.Overlay
                        show={@state.overlayShown}
                        rootClose=true
                        onHide={=> @setState(overlayShown: false)}
                        placement="bottom"
                        container={@}
                        target={@getPopOverTarget}
                    >
                        <BS.Popover id="popover-positioned-bottom" title="Entries">
                            {entries}
                        </BS.Popover>
                    </BS.Overlay>
                </div>
            </BS.FormGroup>
        </BS.Col>

    render: ->

        body = switch @entry.categories.length
            when 1
                <Category category={@entry.categories.first()}
                    categories={@props.categories} />
            else
                @renderMultiple()

        props = _.without( @props, _.keys(@constructor.propTypes) )

        <BS.Col  {...props} className="categories">
            {body}
            <BS.FormGroup className='add'>
                <LC.IconButton icon="plus" onClick={@addCategory} />
            </BS.FormGroup>
        </BS.Col>
