##=require skr/vendor

class Skr.Screens.Invoice.Payment extends Lanes.React.Component

    statics:
        onPayment: (modal, ev) ->
            {invoice, payment} = modal.refs.body
            payment.save(include: 'invoice').then (pymnt) ->
                invoice.amount_paid = invoice.amount_paid.minus(pymnt.amount)
                modal.hide() unless pymnt.hasErrors

        display: (viewport, invoice) ->
            viewport.displayModal
                title: "Accept Payment", size: 'lg',
                onCancel: (m) ->
                    unsaved = invoice.payments.filter (pymnt) -> not pymnt.isNew()
                    invoice.payments.remove(unsaved)
                    m.hide()
                onOk: @onPayment, className: "invoice-payment"
                invoice: invoice
                body: Skr.Screens.Invoice.Payment

    getInitialState: ->
        type: 'credit-card'

    dataObjects:
        invoice: 'props'
        payment: ->
            payment = @props.invoice.payments.find (pymnt) -> pymnt.isNew()
            payment ||= this.props.invoice.payments.add({
                amount: @props.invoice.open_amount
            })
            payment

    onEnter: -> @props.modal.onButton()

    onTypeChange: (ev) ->
        @setState(type: ev.target.value)

    visitPayment: (payment) ->
        @props.modal.hide()
        Lanes.Screens.Definitions.all.get('payments')
            .display(props: {payment: payment})

    PreviousPayments: (props) ->
        previous = props.invoice.payments.filter (pymnt) -> not pymnt.isNew()
        return null if _.isEmpty(previous)

        <BS.Table striped bordered condensed className="prior-payments">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Info</th>
                    <th className="align-right">Amount</th>
                </tr>
            </thead>
            <tbody>
                {for pym in previous
                    <tr key={pym.id}>
                        <td><a onClick={_.partial(@visitPayment, pym)}>{pym.visible_id}</a></td>
                        <td>{Lanes.u.format.shortDateTime(pym.date)}</td>
                        <td>{pym.describe()}</td>
                        <td className="align-right">{Lanes.u.format.currency(pym.amount)}</td>
                    </tr>}
            </tbody>
        </BS.Table>

    NewPayment: (props) ->
        {invoice} = props
        return null if invoice.isPaidInFull()

        <div className="new-payment">
            <BS.FormGroup className="toggles">
                <BS.Radio onChange={@onTypeChange}
                    checked={@state.type is 'cash'}
                    name="type" value="cash" inline>Cash</BS.Radio>
                <BS.Radio onChange={@onTypeChange}
                    checked={@state.type is 'credit-card'}
                    name="type" value="credit-card" inline>Credit Card</BS.Radio>
            </BS.FormGroup>

            <BS.Row>
                {<Skr.Components.CreditCardForm
                    card={@payment.credit_card } /> if @state.type is 'credit-card'}
            </BS.Row>

            <LC.ErrorDisplay model={@payment} />

            <BS.Row className="input-fields">
                <LC.DisplayValue name='total' getValue={->
                    Lanes.u.format.currency(@total)
                } model={invoice} align='right' />

                <LC.DisplayValue name='prev_amount_paid' label='Amount Paid' getValue={->
                    Lanes.u.format.currency(@amount_paid)
                } model={invoice} align='right' />

                <LC.NumberInput label='Amount' editOnly autoFocus getValue={->
                    Lanes.u.format.currency(@amount)
                } onEnter={@onEnter} name='amount' align='right' model={@payment} />
            </BS.Row>
        </div>

    render: ->
        <LC.ScreenWrapper identifier="payment">
            <@PreviousPayments invoice={@invoice} />
            <@NewPayment invoice={@invoice} />
        </LC.ScreenWrapper>
