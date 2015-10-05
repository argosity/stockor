class Skr.Models.InvLine extends Skr.Models.Base

    mixins: [ Skr.Models.Mixins.SkuLine ]

    props:
        id:         {type:"integer"}
        invoice_id: {type:"integer", required:true}
        sku_loc_id: {type:"integer", required:true}
        pt_line_id: "integer"
        so_line_id: "integer"
        price:      {type:"bigdec", required:true}
        sku_code:   {type:"string", required:true}
        description:{type:"string", required:true}
        uom_code:   {type:"string",  default: 'EA'}
        uom_size:   {type:"integer", default: 1}
        position:   {type:"integer", required:true}
        qty:        {type:"integer", required:true}
        is_revised: {type:"boolean", required:true, default:false}

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

    copyFrom: (other) ->
        super
        if other instanceof Skr.Models.SoLine
            @so_line.copyFrom(other)
            @unset('id')
        @

    dataForSave: ->
        # lines should never send associations
        super(excludeAssociations: true)
