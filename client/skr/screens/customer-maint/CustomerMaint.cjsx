class Skr.Screens.CustomerMaint extends Lanes.React.Screen

    dataObjects:
        customer: ->
            @props.customer || new Skr.Models.Customer
        query: ->
            new Lanes.Models.Query({
                modelClass: Skr.Models.Customer, fields: [
                    {id:'id', visible: false}
                    'code', 'name', 'notes',
                    { id: 'open_balance', flex: 0.5, textAlign: 'center' }
                ]
            })
        glAccounts: ->
            new Skr.Models.GlAccount.Collection

    modelForAccess: 'customer'

    onSave: ->
        @customer.save()

    onFinderSelect: (model) ->
        model.withAssociations('billing_address', 'shipping_address')
            .then => @data.rebind(customer: model)

    componentDidMount: ->
        _.defer =>
            @getDOMNode().querySelector('input[name=code]').value = "STOCKOR\n"
            #@getDOMNode().querySelector('.icon-search')?.click()

    render: ->
        <div className="container">
            <LC.Toolbar observeChanges={@customer} onSave={@onSave}/>
            <LC.ErrorDisplay model={@customer} />
            <BS.Row>
                <BS.Col sm=4>
                    <LC.RecordFinder model={@customer} autoFocus
                        query={@query} onRecordSelect={@onFinderSelect} />
                </BS.Col>
                <BS.Col sm=8>
                    <LC.TextField name="name" readonly model={@customer} />
                </BS.Col>
            </BS.Row>
            <BS.Row>
                <BS.Col sm=12>
                    <LC.TextArea
                        name="notes"
                        model={@customer} />
                </BS.Col>
            </BS.Row>
            <BS.Row>
                <BS.Col lg=6>
                    <LC.SelectField
                        label="Receivables Account"
                        name="gl_receivables_account"
                        collection={@glAccounts}
                        labelField="combined_name"
                        model={@customer} />
                </BS.Col>
            </BS.Row>
            <BS.Row>
                <BS.Col lg=6>
                    <LC.FieldSet title="Billing Address">
                        <Skr.Components.Address model={@customer.billing_address}  />
                    </LC.FieldSet>
                </BS.Col>
                <BS.Col lg=6>
                    <Skr.Components.Address model={@customer.shipping_address} />
                </BS.Col>
            </BS.Row>

            <div className="row">

            </div>

            <div className="row">

            </div>

        </div>




    # mixins:[
    #     Lanes.Screens.Mixins.Editing
    # ]

    # useFormBindings: true

    # subviews:
    #     terms:
    #         component: 'SelectField'
    #         model: 'model'
    #         options: { association: 'terms', mappings: { title: 'code' } }
    #     billaddr:
    #         component: 'Address'
    #         model: 'model.billing_address'
    #         options: { field_name: 'billing_address_id' }
    #     shipaddr:
    #         component: 'Address'
    #         model: 'model.shipping_address'
    #         options: ->{ copyFrom: this.billaddr, field_name: 'shipping_address_id' }

    # finderOptions: ->
    #     modelClass: Skr.Models.Customer
    #     title: 'Find Customer',
    #     invalid_chars: Skr.Models.Mixins.CodeField.invalidChars
    #     withAssociations: ['billing_address', 'shipping_address', 'terms']
    #     fields: [ 'code', 'name', 'notes', 'credit_limit' ]
