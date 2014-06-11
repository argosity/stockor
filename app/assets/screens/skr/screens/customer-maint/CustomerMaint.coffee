class Skr.View.Screens.CustomerMaint extends Skr.View.Screen

    subViews:
        '#grid':
            component: 'Grid'
            collection: 'customers'

    initialize:->
        @customers=new Skr.Data.Customers


    render: ->
        this.$el.html('<h3>Hello Customers!</h3><div id="grid"></div>')
        super
        this
