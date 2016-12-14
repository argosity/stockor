Field = (props) ->
    return null if props.fields? and not _.includes(props.fields.display, props.name)
    required =  _.includes(props.fields?.required, props.name)

    <label className={_.classnames({required})}>
        <span
            title={"Required" if required}
        >
            {props.label or _.titleize(props.name)}:
        </span>
        <input
            onChange={props.onChange} type='text'
            name={props.name} />
    </label>

class Skr.Api.Components.AddressForm extends Skr.Api.Components.Base

    modelBindings:
        address: 'props'

    propTypes:
        fields: React.PropTypes.shape(
            required: React.PropTypes.arrayOf(React.PropTypes.string)
            display:  React.PropTypes.arrayOf(React.PropTypes.string)
        )

    setField: (ev) ->
        @address[ev.target.name] = ev.target.value

    render: ->

        fieldProps = _.extend({
            onChange: @setField
        }, @props)

        <div className="address">
            <div className="fields">
                <Field name='name' {...fieldProps} />
                <Field name='phone' {...fieldProps} />
                <Field name='email' {...fieldProps} />
                <Field name='line1' label='Address line 1' {...fieldProps} />
                <Field name='line2' label='Address line 2' {...fieldProps} />
                <Field name='city'  {...fieldProps} />
                <Field name='state' {...fieldProps} />
                <Field name='postal_code' label='Zip' {...fieldProps} />
            </div>
        </div>
