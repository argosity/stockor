##= require_self
##= require ./Form
##= require ./Grid
##= require ./Categories
##= require ./ApprovalRequest
##= require ./ApproveDialog

isApproved = (row) ->
    !!row[2]

getCategoryVal = (type, fields, q) ->
    list = fields[1]
    if _.isArray(q.syncOptions.with)
        _.reduce(list, (amt, cat) ->
            amt + cat[type]
        , 0)
    else
        category_id = q.syncOptions.with.with_category_details
        cat = _.find(list , (f) ->
            f.category_id = category_id
        )
        cat?[type] || 0.0

BALANCE_FIELD = {
    id: 'balance', title: 'Balance',
    fixedWidth: 100, textAlign: 'right', query: false,
    format: (e, fields, q) ->
        Lanes.u.format.currency getCategoryVal('balance', fields, q)
}

class Skr.Screens.ExpenseEntry extends Skr.Screens.Base

    getInitialState: ->
        isReviewing: false

    syncOptions:
        include: ['categories', 'attachments' ]

    modelBindings:
        categories: ->
            Skr.Models.ExpenseCategory.Collection.fetch()

        entry: ->
            @loadOrCreateModel({
                syncOptions: @syncOptions, klass: Skr.Models.ExpenseEntry
                prop: 'entry', attribute: 'id'
            })

        query: ->
            new Lanes.Models.Query({
                autoRetrieve: true, sortAscending: false,
                src: Skr.Models.ExpenseEntry,
                syncOptions: _.extend({}, @syncOptions,
                    with: ['with_category_details']
                ),
                fields: [
                    { id: 'id', visible: false }
                    { id: 'category_list', visible: false }
                    { id: 'gl_transaction_ids', visible: false }
                    { id: 'occured', fixedWidth: 200, textAlign: 'center', format: Lanes.u.format.dateTime }
                    { id: 'name', flex: 1 }
                    {
                        id: 'amount',  fixedWidth: 100, textAlign: 'right', query: false,
                        format: (e, fields, q) ->
                            Lanes.u.format.currency getCategoryVal('amount', fields, q)
                    }
                ]
            })

    getSelectionAttributes: ({row}) ->
        if isApproved(row) then {checked: true, disabled: true} else {}

    setReviewState: (@isReviewing) ->
        @setState({@isReviewing})
        @query.syncOptions.with = ['with_category_details']
        if @isReviewing
            @query.syncOptions.queryParams = {review: true}
            @query.syncOptions.with.push('with_user_logins')
            @query.fields.add({ id: 'created_by_user.login', title: 'User', fixedWidth: 120 }, at: 3)
            @gridSelections = new LC.Grid.Selections(
                onChange: @rowSelectChanged, attributesGetter: @getSelectionAttributes
            )
            @query.fields.add(@gridSelections, at: 2)
        else
            delete @query.syncOptions.queryParams
            delete @gridSelections
            @query.fields.remove(['selected', 'created_by_user.login'])

        @query.results.reload()

    rowSelectChanged: ->
        @forceUpdate()

    onEntrySelect: (entry, index) ->
        entry.fetch(@syncOptions).then (e) =>
            @modelBindings.reset({entry})
            @query.markModified()
            @refs.form.focus()

    onEntryReset: ->
        entry = new Skr.Models.ExpenseEntry
        entry.categories.add({})
        @modelBindings.reset({entry})
        @refs.form.focus()

    onCategoryChange: ->
        @query.results.reload()

    onEntrySave: ->
        isNew = @entry.isNew()
        isCategoriesChanged = @entry.categories.isDirty()
        @entry.save().then =>
            return if @entry.hasErrors
            if isNew or isCategoriesChanged
                @query.results.reload()
            else
                @query.results.saveModelChanges(@entry)
            @onEntryReset()

    onConfirmationToggle: (selected) ->
        @query.results.eachRow (row, xd) ->
            LC.Grid.Selections.setRow(row, xd, selected)
        @query.markModified()

    onApproved: ->
        @refs.overlay.hide()
        @query.results.reload()

    selectedState: ->
        none = all = true
        @query.results.eachRow (row, xd) ->
            if LC.Grid.Selections.isSelected(row, xd) and not isApproved(row)
                none = false
            else
                all = false
            if none is false and all is false
                return 'break'
        if all then true else if none then false else null

    onCategorySelect: (category) ->
        if category
            @query.syncOptions.with = { with_category_details:  category.id }
            @query.fields.add(BALANCE_FIELD)
        else
            @query.fields.remove(BALANCE_FIELD.id)
            category = new Skr.Models.ExpenseCategory
            @query.syncOptions.with = [ 'with_category_details' ]
        @setState({category})
        @query.results.reload()

    isRowEditing: (row) ->
        @entry.id is row[0]

    render: ->
        selectionState = @selectedState()
        <LC.ScreenWrapper flexVertical
            identifier="expense-entry"
            className={_.classnames('is-reviewing': @isReviewing)}
        >

            <Skr.Screens.ExpenseEntry.Form
                ref="form"
                categories={@categories}
                entry={@entry}
                onEntryReset={@onEntryReset}
                onEntrySave={@onEntrySave}
            />

            <Skr.Screens.ExpenseEntry.Grid
                onCategorySelect={@onCategorySelect}
                setReviewState={@setReviewState}
                isReviewing={@isReviewing}
                isRowFocused={@isRowEditing}
                isConfirmationChecked={selectionState}
                categories={@categories}
                onRecordSelect={@onEntrySelect}
                onConfirmationToggle={@onConfirmationToggle}
                query={@query}
            />

            <BS.Row className='footer'>
                <BS.Col sm=12>
                    <BS.OverlayTrigger
                        rootClose={true} container={@} trigger="click" ref="overlay" placement="top"
                        overlay={<Skr.Screens.ExpenseEntry.Approve
                            query={@query} onApproved={@onApproved}/>}
                    >
                        <BS.Button bsStyle="primary" disabled={selectionState is false}>Approve</BS.Button>
                    </BS.OverlayTrigger>
                </BS.Col>
            </BS.Row>

        </LC.ScreenWrapper>
