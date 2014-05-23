class Skr.View.MenuToggle extends Skr.View.Base

    template: 'menu_toggle'

    events:
        'click .menu-toggle': 'toggleMenu'

    initialize: ->
        @model ||= new Skr.Data.MenuState


    toggleMenu: ->
        @model.nextState()
        console.log @model.get('state')
