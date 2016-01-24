class Skr.Models.Base extends Lanes.Models.Base

    abstractClass: true

    constructor: -> super

    dataTypes:
        visible_id:
            set: (newVal) ->
                val = parseInt(newVal, 10) unless _.isBlank(newVal)
                {val, type: 'visible_id'}


Skr.Models.Mixins ||= {}
