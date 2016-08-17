class Skr.Screens.ExpenseEntry.Grid extends Lanes.React.Component

    propTypes:
        onRecordSelect: React.PropTypes.func.isRequired

    modelBindings:
        categories: 'props'
        query: 'props'

    getInitialState: ->
        category: new Skr.Models.ExpenseCategory

    getCurrentCategory: -> @state.category

    renderReviewCheckbox: ->
        return null unless Lanes.current_user.roles.includes('accounting')
        <BS.Checkbox className="all-users" checked={!!@query.syncOptions.queryParams?.review}
            onChange={(ev) => @props.setReviewState(ev.target.checked)}
        > Review</BS.Checkbox>

    renderApproveToggle: ->
        return null unless @props.isReviewing
        <span className="approved-toggle">
            <LC.IndeterminateCheckbox checked={@props.isConfirmationChecked}
                onChange={(ev) => @props.onConfirmationToggle(ev.target.checked)}
            />
        </span>

    toolbarControls: ->
        <BS.Navbar.Form className="controls">
            {@renderApproveToggle()}
            <div className="spacer" />
            <div className="right">
                {@renderReviewCheckbox()}
                <SC.ExpenseCategoryFinder
                    choices={@categories.models} fetchOnSelect={false}
                    withClearBtn fieldOnly editOnly selectField unlabeled
                    model={@state.category} getSelection={@getCurrentCategory}
                    setSelection={@props.onCategorySelect} />
                </div>
        </BS.Navbar.Form>

    render: ->
        <LC.Grid
            expandY={true}
            onColumnClick={@onColumnSort}
            query={@query} height=200 autoLoadQuery
            onSelectionChange={@props.onRecordSelect}
            toolbarChildren={@toolbarControls()}
        />
