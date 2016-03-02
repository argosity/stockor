class Skr.Screens.PaymentCategory extends Skr.Screens.Base

    dataObjects:
        category: ->
            @loadOrCreateModel({
                klass: Skr.Models.PaymentCategory
                prop: 'category', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'category')

    render: ->
        <LC.ScreenWrapper identifier="payment-category">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>

                <SC.PaymentCategoryFinder name='code'
                    commands={@state.commands} model={@category} />

                <LC.Input sm=9 name='name' model={@category} />

                <SC.GlAccountChooser sm=3 label="GL Account"
                    name="gl_account" model={@category} />

            </BS.Row>

        </LC.ScreenWrapper>
