class ScreenList extends Skr.View.Base
    el: "<li><a href='#'><span></span><i></i></a></li>"

    events:
        click: ->
            this.model.display()

    bindings:
        title: 'span'
        icon: { selector: 'i', elAttribute: 'class' }



class ScreenGroup extends Skr.View.Base
    el: -> '<li><a href="#" class="expand level-closed"><span class="group"></span><i class="group"></i></a><ul></ul></li>'
    events:
        click: -> this.model.setActive()

    bindings:
        title: 'span.group'
        icon: { selector: 'i.group', elAttribute: 'class' }
        active: Skr.View.fn.toggleClass('active')

    events:
        'tap .expand': 'toggleMenu'

    toggleMenu: (ev)->
        @model.toggle('active')

    subViews:
        screens:
            selector: 'ul'
            view: ScreenList
            collection: 'screens'

    initialize: ->
        @screens =  @model.screens()
        super


class Skr.Workspace.UI.ScreensMenu extends Skr.View.Base

    template: 'skr/workspace/ui/screens-menu'

    attributes:
        class: "screens-menu"

    subViews:
        navigation:
            selector: 'ul.navigation'
            view: ScreenGroup
            collection: 'groups'

    initialize: ->
        @groups = Skr.Data.Screens.groups
        this
