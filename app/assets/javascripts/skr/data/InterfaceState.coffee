class Skr.Data.InterfaceState extends Skr.Data.Model

    @SCREENS_MENU_SIZES = [ 'wide', 'narrow', 'hidden' ]

    defaults:
        screen_menu_size: @SCREENS_MENU_SIZES[0]

    initialize: ->
        super(arguments)
        @screens = new Skr.Data.ScreenSet

    nextSidebarState: ->
        next_index = InterfaceState.SCREENS_MENU_SIZES.indexOf( this.get('screen_menu_size') ) + 1
        next_index = 0 if next_index >= InterfaceState.SCREENS_MENU_SIZES.length
        this.set( screen_menu_size: InterfaceState.SCREENS_MENU_SIZES[next_index] )
