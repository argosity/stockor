class ScreenView extends Skr.Data.Model
    defaults:
        active: false

    initialize: (options)->
        super
        @screen=options.screen
        Skr.Data.Screens.displaying.add( this )
        this.set(active:true)

    view: ->
        @viewInstance ||= ( new @screen.viewModel( screen: this.screen ) ).render()

    remove: ->
        Skr.Data.Screens.displaying.remove( this )


class Skr.Data.Screen extends Skr.Data.Model

    initialize: ->
        @views = []
        super

    isActive:->
        this.get('active')

    setActive:->
        this.set(active: true)

    _setDisplaying: ->
        @views.push( new ScreenView( screen: this ) )

    display: ->
        @viewModel ||= Skr.View.Screens[this.get('view')]
        if @viewModel?
           this._setDisplaying()
        else
            this.set(loading:true)
            Skr.load( this.get('files'), ->
                @viewModel = Skr.View.Screens[this.get('view')]
                this._setDisplaying()
                this.set(loading:false)
            , this )


class Skr.Data.ScreenSet extends Skr.Data.Collection

    model: Skr.Data.Screen

    initialize: (models, options={})->
        this.on( 'change:active', this.onActiveChange ) if options.single_active_only

    register: (spec)->

    addScreen: (screen)->
        screen = this.add( screen )
        screen.set(active:true)

    active: ->
        @findWhere( active: true )

    onActiveChange: (changed,active)->
        return unless active
        #this.off('change:active')
        this.each (screen)->
            screen.set( active: false ) unless screen == changed
        #this.on( 'change:active', this.onActiveChange )


class Skr.Data.MenuGroup extends Skr.Data.Model
    screens: ->
        new Skr.Data.ScreenSet( Skr.Data.Screens.all.where( group_id: this.id ) )

class Skr.Data.MenuGroupSet extends Skr.Data.Collection
    model: Skr.Data.MenuGroup


Skr.Data.Screens = {
    all: new Skr.Data.ScreenSet
    displaying: new Skr.Data.ScreenSet([],{ single_active_only: true })
    groups:  new Skr.Data.MenuGroupSet
    available_groups: ->
        Skr.Data.MenuGroupSet.where({ id:  available.groupBy (screen)-> screen.get('group_id').keys })

    register: (spec)->
        this.all.add( spec )
}