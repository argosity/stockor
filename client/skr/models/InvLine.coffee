class Skr.Models.InvLine extends Skr.Models.Base

    mixins: [ Skr.Models.Mixins.SkuLine ]

    props:
        id:         {type:"integer"}
        invoice_id: {type:"integer"}
        sku_loc_id: {type:"integer"}
        pt_line_id: "integer"
        so_line_id: "integer"
        price:      {type:"bigdec"}
        sku_code:   {type:"string"}
        description:{type:"string"}
        uom_code:   {type:"string",  default: 'EA'}
        uom_size:   {type:"integer", default: 1}
        position:   {type:"integer"}
        qty:        {type:"bigdec",  default:"0"}
        is_revised: {type:"boolean", default:false}

    associations:
        invoice:  { model: "Invoice" }
        so_line:  { model: "SoLine" }
        pt_line:  { model: "PtLine" }
        sku_loc:  { model: "SkuLoc" }
        sku:      { model: "Sku" }
        location: { model: "Location" }
        sku_tran: { model: "SkuTran" }

    derived:
        location_id:
            deps: ['invoice'], fn: ->
                @invoice.location_id

    dataForSave: ->
        # lines should never send associations
        super(excludeAssociations: true)


    @fromSoLine: (l) ->
        invl = new Skr.Models.InvLine( l.serialize() )
        invl.unset('id')
        invl
