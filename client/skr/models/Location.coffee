SHARED_DATA = null
SHARED_COLLECTION = null

class Skr.Models.Location extends Skr.Models.Base

    mixins: [ 'FileSupport', 'HasCodeField' ]

    props:
        id:            {type:"integer"}
        code:          {type:"code"}
        name:          {type:"string"}
        address_id:    {type:"integer"}
        is_active:     {type:"boolean", "default":true}
        gl_branch_code:{type:"string", "default":"01"}
        options: "any"

    associations:
        address:    { model: "Address" }
        sku_locs:   { collection: "SkuLoc" }
        logo:       { model: "Lanes.Models.Asset" }
        print_logo: { model: "Lanes.Models.Asset" }

    @initialize: (data) ->
        SHARED_DATA = data.locations

    addChangeSet: (change) ->
        if change.update.logo
            change.update.logo[1] = change.update.logo[1].logo
        super

Object.defineProperties Skr.Models.Location, {
    all:
        get: ->
            SHARED_COLLECTION ||= new Skr.Models.Location.Collection( SHARED_DATA )
    default:
        get: ->
            @all.findWhere(code: 'DEFAULT') || @all.first()
}
