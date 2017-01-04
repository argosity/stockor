class Skr.Components.Address extends Lanes.React.Component

    propTypes:
        title: React.PropTypes.string
        model: Lanes.PropTypes.State.isRequired
        copyFrom: Lanes.PropTypes.State

    modelBindings:
        model: 'props'
        copyFrom: -> @props.copyFrom or false

    setModelState: (addr) ->
        if (addr is @props.copyFrom)
            for attr, val of addr.changedAttributes() when attr isnt 'isDirty'
                @model[attr] = val if addr.previous(attr) is @model[attr]
        else
            @forceUpdate()

    renderTitle: ->
        <BS.Row>
            <BS.Col xs=12>
                <h3 className="address-title">{@props.title}</h3>
            </BS.Col>
        </BS.Row>

    render: ->
        colProps = _.omit(@props,  _.keys(@constructor.propTypes))
        colProps.className = _.classnames("address", @props.className)

        <BS.Col {...colProps}>
            {@renderTitle() if @props.title}
            <BS.Row>
                <LC.Input name="name" model={@model} xs=12 />
            </BS.Row>
            <BS.Row>
                <LC.Input name="phone" model={@model} sm=6 />
                <LC.Input name="email" model={@model} sm=6 />
            </BS.Row>
            <BS.Row>
                <LC.Input name="line1" model={@model} md=6 />
                <LC.Input name="line2" model={@model} md=6 />
            </BS.Row>
            <BS.Row>
                <LC.Input name="city" model={@model} md=7 />
                <LC.Input name="state" model={@model} xs=8 md=3 />
                <LC.Input name="postal_code" model={@model} xs=4 md=2 />
            </BS.Row>
        </BS.Col>
