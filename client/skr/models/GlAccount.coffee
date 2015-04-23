class Skr.Models.GlAccount extends Skr.Models.Base

    cacheDuration: [1,'day']

    props:
        id:         {"type":"integer","required":true}
        number:     {"type":"string","required":true}
        name:       {"type":"string","required":true}
        is_active:  {"type":"boolean","required":true,"default":"true"}

    derived:
        combined_name:
            deps: ['number','name'], fn:->
                "#{@number}: #{@name}"


    @initialize: (data)->
        this.default_ids = data.default_gl_account_ids
        ms=Lanes.Vendor.Moment.duration(this::cacheDuration...).asMilliseconds()
        Lanes.Models.ServerCache.store(this::urlRoot(), data.gl_accounts, ms)
