unMaskInvalidField = (model, name) ->
    model.unmaskInvalidField(name)

Field = (props) ->

    return null if props.fields?.display and not _.includes(props.fields.display, props.name)
    required =  _.includes(props.fields?.required, props.name)
    errorMsg = props.address.invalidMessageFor(props.name)

    <label className={
        _.classnames('field', props.name, {required, 'is-invalid': !!errorMsg})
    }>
        <span
            className="title"
            title={"Required" if required}
        >
            {props.label or _.titleize(props.name)}:
        </span>
        <input
            onBlur={_.partial(unMaskInvalidField, props.address, props.name)}
            onChange={props.onChange} type='text'
            name={props.name} />
        <span className='invalid-msg'>
            {errorMsg}
        </span>
    </label>

class Skr.Api.Components.AddressForm extends Skr.Api.Components.Base

    modelBindings:
        address: 'props'

    bindEvents:
        address: "all"

    componentWillMount: ->
        if @props.fields?.required?
            @address.requiredAttributes = @props.fields.required

    propTypes:
        fields: React.PropTypes.shape(
            required: React.PropTypes.arrayOf(React.PropTypes.string)
            display:  React.PropTypes.arrayOf(React.PropTypes.string)
        )

    setField: (ev) ->
        @address[ev.target.name] = ev.target.value

    render: ->
        fieldProps = _.extend({
            address: @address, onChange: @setField
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
