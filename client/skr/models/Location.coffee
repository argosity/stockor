class Skr.Models.Location extends Skr.Models.Base

    cacheDuration: [1, 'day']

    mixins: [ Lanes.Models.Mixins.FileSupport ]

    props:
        id:            {type:"integer"}
        code:          {type:"string"}
        name:          {type:"string"}
        address_id:    {type:"integer"}
        is_active:     {type:"boolean", "default":true}
        gl_branch_code:{type:"string", "default":"01"}
        logo:     "file"
        options:  "any"

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
