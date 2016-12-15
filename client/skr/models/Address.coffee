CHECKS =
    phone: /^[0-9()\-,\.]+$/
    email: /(.+)@(.+){2,}\.(.+){2,}/

class Skr.Models.Address extends Skr.Models.Base

    props:
        id:         {type:"integer"}
        name:       "string"
        email:      "string"
        phone:      "string"
        line1:      "string"
        line2:      "string"
        city:       "string"
        state:      "string"
        postal_code:"string"

    session:
        parent: 'object'

    modelForAccess: ->
        @parent || this

    clonedAttributes: ->
        _.omit @serialize(), 'id'

    invalidMessageFor: (attr) ->
        invalidMsg = super(attr)
        if !invalidMsg and CHECKS[attr] and @shouldCheckFieldValidity(attr) and !CHECKS[attr].test(this[attr])
            return "is not a valid #{attr}"
        else
            invalidMsg

    toString: ->
        line3 = _.compact([ @city, @state, @postal_code ]).join(' ')
        _.compact([@line1, @line2, line3]).join("\n") || ''
