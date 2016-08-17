class Skr.Screens.ExpenseCategories extends Skr.Screens.Base

    modelBindings:
        category: ->
            @loadOrCreateModel({
                klass: Skr.Models.ExpenseCategory
                prop: 'category', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'category')

    render: ->
        <LC.ScreenWrapper identifier="expense-categories">
            <SC.ScreenControls commands={@state.commands} />

            <BS.Row>
                <SC.ExpenseCategoryFinder sm=2 autoFocus editOnly
                    commands={@state.commands} model={@category}
                />

                <LC.Input sm=9 name='name' model={@category} />
            </BS.Row>
            <BS.Row>
                <SC.GlAccountChooser sm=3 label="GL Account"
                    name="gl_account" model={@category} />

                <LC.ToggleField model={@category} name='is_active' sm=2 />
            </BS.Row>

        </LC.ScreenWrapper>
