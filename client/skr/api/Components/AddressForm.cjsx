class Skr.Api.Components.AddressForm extends Skr.Api.Components.Base

    dataObjects:
        address: 'props'

    setField: (ev) ->
        @address[ev.target.name] = ev.target.value

    render: ->
        fieldProps =
            onChange: @setField
            type: 'text'

        <div className="address">
            <label>
                <span>Name:</span>
                <input {...fieldProps} name="name"  />
            </label>
            <label>
                <span>Email:</span>
                <input {...fieldProps} name="email" />
            </label>
            <label>
                <span>Phone:</span>
                <input {...fieldProps} name="phone" />
            </label>
            <label>
                <span>Address line 1:</span>
                <input {...fieldProps} name="line1" />
            </label>
            <label>
                <span>Address line 2:</span>
                <input {...fieldProps} name="line2" />
            </label>
            <label>
                <span>City:</span>
                <input {...fieldProps} name="city" />
            </label>
            <label>
                <span>State:</span>
                <input {...fieldProps} name="state" />
            </label>
            <label>
                <span>Postal Code:</span>
                <input {...fieldProps} name="postal_code" />
            </label>
        </div>
