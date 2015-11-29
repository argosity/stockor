class Skr.Screens.CustomerMaint extends Lanes.React.Screen

    dataObjects:
        customer: ->
            @props.customer || new Skr.Models.Customer

    getInitialState: ->
        commands: new Lanes.Screens.Commands(this, modelName: 'customer')

    modelForAccess: 'customer'

    componentDidMount: ->
        @state.commands.toggleEdit()
        finder = @refs.finder.refs.finder
        finder._setValue('GOAT')
        finder.loadCurrentSelection()

    setForm: (type, name) ->
        @customer.forms = _.extend(@customer.forms, {"#{type}": name})

    FormChooser: (props) ->
        label = "#{_.field2title(props.type)} Form"
        choices = Skr.Models[_.classify(props.type)].Templates
        <LC.FormGroup label={label} sm=3>
            <Lanes.Vendor.ReactWidgets.DropdownList
                data={choices}
                value={@customer.forms?[props.type] or 'default'}
                onChange={_.partial(@setForm, props.type)}
            />
        </LC.FormGroup>

    render: ->
        <LC.ScreenWrapper identifier="customer-maint">
            <Lanes.Screens.CommonComponents commands={@state.commands} />
            <BS.Row>
                <SC.CustomerFinder sm=4 editOnly ref="finder"
                    syncOptions={include: ['billing_address', 'shipping_address']}
                    commands={@state.commands} model={@customer} />
                <LC.Input sm=8 name="name" model={@customer} />
            </BS.Row>
            <BS.Row>
                <LC.Input sm=12
                    type='textarea'
                    name="notes"
                    model={@customer} />
            </BS.Row>
            <BS.Row>
                <SC.GlAccountChooser sm=3 model={@customer}
                    label="Receivables Account" name="gl_receivables_account"/>
                <SC.TermsChooser model={@customer} sm=3 />
                <@FormChooser type="sales_order" />
                <@FormChooser type="invoice" />
            </BS.Row>
            <BS.Row>
                <LC.FieldSet sm=12 title="Address">
                    <SC.Address lg=6 title="Billing"
                        model={@customer.billing_address}  />
                    <SC.Address lg=6 title="Shipping"
                        model={@customer.shipping_address} />
                </LC.FieldSet>
            </BS.Row>
        </LC.ScreenWrapper>
