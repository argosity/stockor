class Skr.Models.Payment extends Skr.Models.Base

    props:
        id:             {type:"integer"}
        visible_id:     {type:"string"}
        hash_code:      {type:"string"}
        bank_account_id:{type:"integer"}
        category_id:    {type:"integer"}
        vendor_id:      "integer"
        location_id:    "integer"
        amount:         {type:"bigdec",  required:true}
        check_number:   {type:"integer"}
        date:           {type:"date", default: ->
            new Date
        }
        name:           {type: "string", required: true}
        address:        "string"
        notes:          "string"

    mixins: [ 'PrintSupport', 'HasVisibleId' ]

    associations:
        category:       { model: "PaymentCategory" }
        vendor:         { model: "Vendor" }
        bank_account:   { model: "BankAccount" }
        location:       { model: "Location" }
        gl_transaction: { model: "GlTransaction" }

    events:
        'change:vendor': 'onSetVendor'

    onSetVendor: (newVendor) ->
        return unless newVendor and Lanes.u.isModel(newVendor)
        @name = newVendor.name
        newVendor.withAssociations(['billing_address']).then =>
            @address = newVendor.billing_address.toString()
