class ScreenList extends Skr.View.Base
    el: -> '<li><a href="#"><span></span><i></i></a></li>'
    events:
        click: ->
            this.model.display()

    bindings:
        title: 'span'
        icon: { selector: 'i', elAttribute: 'class' }


class ScreenGroup extends Skr.View.Base
    el: -> '<li><a href="#" class="expand level-closed"><span></span><i></i></a><ul></ul></li>'
    events:
        click: -> this.model.setActive()

    bindings:
        title: 'span'
        icon: { selector: 'i', elAttribute: 'class' }
        active: { selector: '', elAttribute: 'class', converter: (dir,value)-> if value then "active" else '' }

    events:
        'tap .expand': 'toggleMenu'

    toggleMenu: (ev)->
        @model.toggle('active')

    subViews:
        'ul': {
            view: ScreenList
            collection: 'screens'
        }

    initialize: ->
        @screens =  @model.screens()


class Skr.View.ScreensMenu extends Skr.View.Base

    template: 'screens-menu'

    attributes:
        class: "screens-menu"

    subViews: {
        'ul.navigation': {
            view: ScreenGroup
            collection: 'groups'
        }
    }

    initialize: ->
        @groups = Skr.Data.Screens.groups
        this
