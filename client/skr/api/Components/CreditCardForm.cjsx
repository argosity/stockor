class Skr.Api.Components.CreditCardForm extends Skr.Api.Components.Base

    dataObjects:
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

            <form  className="credit-card section">
                <input {...fieldProps}
                    placeholder="Card number" name="number" />
                <input {...fieldProps} value={@card.name}
                    placeholder="Full name" name="name" />
                <div className="row">
                    <input {...fieldProps} placeholder="MM/YY" name="expiry" />
                    <input {...fieldProps} placeholder="CVC" name="cvc" />
                </div>
            </form>
        </div>
