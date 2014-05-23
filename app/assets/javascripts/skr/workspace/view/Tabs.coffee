class TabView extends Skr.View.Base
    el: -> "<li id='#{this.model.cid}'><a data-toggle='tab'>#{this.model.get('title')}</a></li>"
    events:
        click: -> this.model.setActive()
    bindings: {
        active: { selector: '', elAttribute: 'class', converter: (dir,value)-> if value then "active" else '' }
    }


class Skr.View.Tabs extends Skr.View.Base

    events:{}
    tagName: 'div'
    itemView: TabView

    attributes:
        class: "tabs"

    subViews: {
        '.nav-tabs': {
            view: TabView
            collection: 'collection'
        }
    }

    initialize: ->
        @collection = Skr.Data.Screens.displaying
        this.listenTo( @collection, "change:active", this.onActiveChange )

    render: ->
        this.$el.html( '''
        <ul class="nav nav-tabs">
        </ul>
        ''')
        super
        return this
