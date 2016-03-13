class Skr.Screens.FreshBooksImport.Import extends Skr.Models.Base

    modelTypeIdentifier: -> 'fresh-books-import'

    props:
        domain:      'string'
        api_key:     'string'
        stage:       {type: 'string', default: 'fetch'}
        ignored_ids: 'object'
        user_mappings: 'object'
        customer_codes: 'object'

    associations:
        job: {model: 'Lanes.Models.JobStatus'}

    hasPendingRecords: ->
        @stage is 'fetch' and @hasRecords() and not @job?.isActive

    hasImportedRecords: ->
        @stage is 'complete' and @hasRecords() and not @job?.isActive

    hasRecords: ->
        not _.isEmpty(@job.data?.output)

    recordTypes: ['clients', 'projects', 'invoices', 'time_entries', 'staff']

    recordsForType: (type) ->
        @job.data.output[type] || []

    isComplete: ->
        @stage is 'complete'

    complete: ->
        @ignored_ids = {}
        for type in @recordTypes
            @ignored_ids[type] = ids = []
            idprop = _.singularize(type) + '_id'
            for record in @recordsForType(type) when record.selected is false
                ids.push(record[idprop])

        @user_mappings = {}
        for row in @recordsForType('staff')
            if row.mapped_user_id
                @user_mappings[row.staff_id] = row.mapped_user_id

        @customer_codes = {}
        for row in @recordsForType('clients')
            if row.customer_code
                @customer_codes[row.client_id] = row.customer_code

        @stage = 'complete'
        @save(excludeAssociations: true)
