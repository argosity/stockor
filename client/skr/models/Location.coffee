class Skr.Models.Location extends Skr.Models.Base

    cacheDuration: [1, 'day']

    props:
        id:            {type:"integer", required:true}
        code:          {type:"string", required:true}
        name:          {type:"string", required:true}
        address_id:    {type:"integer", required:true}
        is_active:     {type:"boolean", required:true, "default":true}
        gl_branch_code:{type:"string", required:true, "default":"01"}

    associations:
        address:  { model: "Address" }
        sku_locs: { collection: "SkuLoc" }

    @initialize: (data) ->
        Lanes.Models.ServerCache.storeRecordData(
            this::urlRoot(), data.locations, this::cacheDuration, 'id'
        )

    @default: ->
        @_default || (
            _.first @Collection.fetch().where(is_active: true)
        )
