SHARED_DATA = null
SHARED_COLLECTION = null

class Skr.Models.Location extends Skr.Models.Base

    cacheDuration: [1, 'day']

    mixins: [ 'FileSupport', 'HasCodeField' ]

    props:
        id:            {type:"integer"}
        code:          {type:"code"}
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
        SHARED_DATA = data.locations


Object.defineProperties Skr.Models.Location, {
    all:
        get: ->
            SHARED_COLLECTION ||= new Skr.Models.Location.Collection( SHARED_DATA )
    default:
        get: ->
            @all.findWhere(code: 'DEFAULT') || @all.first()
}
