class Skr.Screens.FreshBooksImport.Import extends Skr.Models.Base

    modelTypeIdentifier: -> 'fresh-books-import'

    props:
        domain:      'string'
        api_key:     'string'
        stage:       {type: 'string', default: 'fetch'}
        ignored_ids: 'object'

    associations:
        job: {model: 'Lanes.Models.JobStatus'}

    hasPendingRecords: ->
        @stage is 'fetch' and @hasRecords()

    hasImportedRecords: ->
        @stage is 'complete' and @hasRecords()

    hasRecords: ->
        not _.isEmpty(@job.data?.output)

    recordTypes: ['clients', 'projects', 'invoices', 'time_entries', 'staff']

    recordsForType: (type) ->
        @job.data.output[type] || []

    isComplete: ->
        @stage is 'complete'

    complete: ->
        @ignored_ids = {}
        @stage = 'complete'
        for type in @recordTypes
            @ignored_ids[type] = ids = []
            idprop = _.singularize(type) + '_id'
            for record in @recordsForType(type) when record.selected is false
                ids.push(record[idprop])
        @user_mappings = {}
        for row in @recordsForType('staff')
            if row.mapped_user_id
                @user_mappings[row.staff_id] = row.mapped_user_id
        @save(excludeAssociations: true)
