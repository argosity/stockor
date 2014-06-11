
SCREENS_MENU_SIZES = [ 'wide', 'narrow', 'hidden' ]
MENU_NARROW_WIDTH  = 60
MENU_WIDE_WIDTH    = 250
BREAKPOINTS = {
    sm: 750
    md: 970
    lg: 1170
}

class Skr.Data.InterfaceState extends Skr.Data.Model

    # defaults:
    #     screen_menu_size: SCREENS_MENU_SIZES[0]

    initialize: ->
        super
        this.on('change:viewport_width', this.autoAdjustMenuPosition )
        this.on('change:screens_width',  this.setScreenLayout )
        @screens = new Skr.Data.ScreenSet

    nextSidebarState: ->
        next_index = SCREENS_MENU_SIZES.indexOf( this.get('screen_menu_size') ) + 1
        next_index = 0 if next_index >= SCREENS_MENU_SIZES.length
        this.set( screen_menu_size: SCREENS_MENU_SIZES[next_index] )

    setScreenLayout: ->
        width = this.get('screens_width')
        this.set switch
            when width < BREAKPOINTS.sm
                { layout: 'tiny' }
            when width < BREAKPOINTS.md
                { layout: 'sm' }
            when width < BREAKPOINTS.lg
                { layout: 'md' }
            else
                { layout: 'lg' }

    autoAdjustMenuPosition:->
        width = this.get('viewport_width')
        this.set switch
            when width < BREAKPOINTS.sm + MENU_NARROW_WIDTH
                { screen_menu_position:'top',screen_menu_size:'hidden'}
            when width < BREAKPOINTS.md + MENU_WIDE_WIDTH
                { screen_menu_position:'side',screen_menu_size:'narrow'}
            when width < BREAKPOINTS.lg + MENU_WIDE_WIDTH
                { screen_menu_position:'side',screen_menu_size:'narrow'}
            else
                { screen_menu_position:'side',screen_menu_size:'wide'}
