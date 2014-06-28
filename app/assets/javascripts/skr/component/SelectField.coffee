class Skr.Component.SelectField extends Skr.Component.Base

    el: '<select></select>'
    idField: 'id'
    displayField: 'name'

    initialize: (options={})->
        Skr.u.extend(this,Skr.u.pick(options,['idField','displayField']))
        super

    subViews:
        options:
            selector: ''
            collection:'collection'
            template: '<option></option>'
            options: ->
                options = {}
                options[ @idField      ] = { selector: '', elAttribute: 'id' }
                options[ @displayField ] = { selector: '' }
                options
