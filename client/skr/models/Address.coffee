class Skr.Models.Address extends Skr.Models.Base

    FILE: FILE

    props:
        id:         {"type":"integer","required":true}
        name:       "string"
        email:      "string"
        phone:      "string"
        line1:      "string"
        line2:      "string"
        city:       "string"
        state:      "string"
        postal_code:"string"

    modelForAccess: ->
        @parent || this
