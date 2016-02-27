class Skr.Screens.Invoice.Payment extends Lanes.React.Component

    dataObjects:
        invoice: 'props'

    componentDidMount: ->
        @invoice.amount_paid = @invoice.open_amount

    onEnter: -> @props.modal.onButton()

    render: ->
        <div className='payment'>
            <BS.Row>

                <LC.DisplayValue name='total' getValue={->
                    _.sprintf('%0.2f', Number(@total))
                } model={@invoice} align='right' />

                <LC.DisplayValue name='prev_amount_paid' label='Amount Paid' getValue={->
                    _.sprintf('%0.2f', Number(@prev_amount_paid))
                } model={@invoice} align='right' />

                <LC.Input label='Amount' editOnly autoFocus getValue={->
                    _.sprintf('%0.2f', Number(@amount_paid))
                } onEnter={@onEnter} name='amount_paid' align='right' model={@invoice} />

            </BS.Row>
        </div>
