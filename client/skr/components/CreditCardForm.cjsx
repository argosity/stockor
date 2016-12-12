class Skr.Components.CreditCardForm extends Lanes.React.Component

    modelBindings:
        card: 'props'

    setField: (ev) ->
        @card[ev.target.name] = ev.target.value

    componentDidMount: ->
        @cardPreview ||= new Skr.Vendor.Card({
            form: _.dom(@, 'form').el, container: _.dom(@, '.preview').el
        })

    render: ->
        fieldProps =
            onChange: @setField
            type: 'text'

        <div className="credit-card-form section">
            <div className='preview'></div>

            <form  className="credit-card-inputs section">
                <div className="row">
                    <input {...fieldProps}
                        value={@card.number || ''}
                        placeholder="Card number" name="number" />
                    <input {...fieldProps} value={@card.name or ''}
                        placeholder="Full name" name="name" />
                </div>
                <div className="row">
                    <input {...fieldProps}
                        value={@card.expiry || ''} placeholder="MM/YY" name="expiry" />
                    <input {...fieldProps}
                        value={@card.cvc || ''} placeholder="CVC" name="cvc" />
                </div>
            </form>
        </div>
