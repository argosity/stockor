Skr.Screens.Mixins.Editing = {

    included: (klass)->
        klass::domEvents ||= {}
        _.extend(klass::domEvents,{
            'click .btn.save':  'saveRecord'
            'click .btn.reset': 'resetRecord'
            'display-record':   'onRecordTrigger'
        })

        klass::subviews ||= {}
        _.extend(klass::subviews,{
            finder: {
                component: 'RecordFinder'
                options: 'finderOptions'
                model: 'model'
            }
        })

    onRecordTrigger: (ev, model)->
        this.model = model

    resetRecord: ->
        options = _.result(this,'finderOptions')
        this.model = new options.modelClass

    saveRecord: ->
        Lanes.Views.SaveNotify(this, include:['billing_address','shipping_address','terms'])

    initialize: ->
        this.resetRecord()
}
