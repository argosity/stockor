class Skr.Models.Payment extends Skr.Models.Base

    props:
        id:             {type:"integer"}
        visible_id:     {type:"visible_id"}
        hash_code:      {type:"string"}
        bank_account_id:{type:"integer"}
        category_id:    {type:"integer"}
        vendor_id:      "integer"
        invoice_id:     "integer"
        location_id:    {type:"integer", default: ->
            Skr.Models.Location.default.id
        }
        amount:         {type:"bigdec", required: true, default: ->
            _.bigDecimal('0')
        }
        check_number:   {type:"integer"}
        date:           {type:"date", default: ->
            new Date
        }
        name:           {type: "string", required: true}
        address:        "string"
        notes:          "string"
        metadata:       "object"

    mixins: [ 'PrintSupport', 'HasVisibleId' ]

    derived:
        is_incoming: deps:['invoice'], fn: -> !!@invoice
        is_outgoing: deps:['is_incoming'], fn: -> !@is_incoming

    associations:
        category:       { model: "PaymentCategory", readOnly: true}
        invoice:        { model: "Invoice", readOnly: true }
        vendor:         { model: "Vendor", readOnly: true   }
        bank_account:   { model: "BankAccount", readOnly: true  }
        location:       { model: "Location", readOnly: true, default: ->
            Skr.Models.Location.all.get(@location_id) if @location_id
        }
        gl_transaction: { model: "GlTransaction", readOnly: true }
        credit_card:    { model: "CreditCard", inverse: 'payment' }

    events:
        'change:vendor': 'onSetVendor'

    describe: ->
        metadata = _.toSentence( _.map(@metadata, (value, key) ->
            _.titleize(key) + ': ' + value
        ))
        #{@name} #{metadata}"

    onSetVendor: ->
        return unless @vendor and @vendor.isPersistent()
        @name = @vendor.billing_address.name
        @vendor.withAssociations(['billing_address']).then (v) =>
            @address = v.billing_address.toString()
