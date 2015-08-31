class Skr.Models.GlAccount extends Skr.Models.Base

    cacheDuration: [1, 'day']

    props:
        id:         {type:"integer", required:true}
        number:     {type:"string",  required:true}
        name:       {type:"string",  required:true}
        is_active:  {type:"boolean", required:true, "default":true}

    derived:
        combined_name:
            deps: ['number', 'name'], fn: ->
                if @isNew() then "" else "#{@number}: #{@name}"

    @initialize: (data) ->
        this.default_ids = data.default_ids
        Lanes.Models.ServerCache.storeRecordData(
            this::urlRoot(), data.accounts, this::cacheDuration, 'id'
        )
