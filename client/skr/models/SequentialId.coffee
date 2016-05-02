class Skr.Models.SequentialId extends Skr.Models.Base

    props:
        id: 'integer'
        ids:
            type: 'array', required: true, default: -> []

    modelTypeIdentifier: ->
        'sequential-ids'

    updateValue: (id, count) ->
        @ids = _.map @ids, (si) ->
            si = _.clone si
            si.count = parseInt(count) if si.id is id
            si
