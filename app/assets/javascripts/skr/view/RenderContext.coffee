CRUD = ['create','read','update','delete']

class Skr.View.RenderContext

    constructor: ->
        this.reset()

    reset: ()->
        @stack  = []
        @_grants = null

    start: (parent, model)->
        @parent = parent
        @stack = [ [null,model] ]

    push: (identifier, model)->
        @stack.push([identifier,model])
        @_grants = null

    grants: ->
        @_grants ||= Skr.current_user.roles.grantsFor( Skr.u.last(@stack)[1] )

    canRead: (field)->
        this.grants()['read']

    canUpdate: (field)->
        this.grants()['update']

    pop: ->
        @stack.pop()
        @_grants = null
