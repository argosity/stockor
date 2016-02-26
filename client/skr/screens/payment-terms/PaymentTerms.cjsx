class Skr.Screens.PaymentTerms extends Skr.Screens.Base

    dataObjects:
        term: ->
            @loadOrCreateModel({
                klass: Skr.Models.PaymentTerm
                prop: 'term', attribute: 'code'
            })

    getInitialState: ->
        commands: new Skr.Screens.Commands(this, modelName: 'term')

    render: ->
        <LC.ScreenWrapper identifier="payment-terms">
            <SC.ScreenControls commands={@state.commands} />
            <BS.Row>
                <SC.TermsChooser useFinder ref='finder' name='code'
                    sm=3 autoFocus editOnly model={@term}
                    commands={@state.commands} />

                <LC.Input sm=9 name='description' model={@term} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=2 name='discount_days' model={@term} />
                <LC.Input sm=2 name='discount_amount' model={@term} />
            </BS.Row>
        </LC.ScreenWrapper>
