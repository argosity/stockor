SHARED_DATA = null
SHARED_COLLECTION = null

class Skr.Models.GlAccount extends Skr.Models.Base

    props:
        id:          {type:"integer"}
        number:      {type:"string",  required:true}
        name:        {type:"string",  required:true}
        description: {type: 'string', default: ''  }
        is_active:   {type:"boolean", default: true}

    # optional attributes from trial balance view
    session:
        balance:       {type:"bigdec"}
        branch_number: {type:"string"}

    derived:
        combined_name:
            deps: ['number', 'name'], fn: ->
                if @number and @name then "#{@number}: #{@name}" else ''

    @initialize: (data) ->
        this.default_ids = data.default_ids
        SHARED_DATA = data.accounts


Object.defineProperty Skr.Models.GlAccount, 'all',
    get: ->
        SHARED_COLLECTION ||= new Skr.Models.GlAccount.Collection(
            SHARED_DATA, comparator: 'number'
        )
