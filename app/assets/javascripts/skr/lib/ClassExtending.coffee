ExtendClass = (ampersand_base, parent, child)->
    Skr.lib.ModuleSupport.includeInto(child)
    parent.extended(child) if Skr.u.isFunction(parent.extended)
    child = ampersand_base.extend.call(parent, child.prototype )
    if child.prototype.mixins
        child.include(mixin) for mixin in child.prototype.mixins

    child.extend = (klass)->
        ExtendClass( ampersand_base, child, klass )
    child.__super__ = parent.prototype

    parent.after_extended(child) if Skr.u.isFunction(parent.after_extended)
    child


Skr.lib.CreateExtendsChain = ( ampersand_base, base )->
    return (klass)->
        ExtendClass( ampersand_base, this, klass )
    base.__super__ = ampersand_base.prototype
    base

Skr.lib.MakeBaseClass = ( ampersand_base, base )->
    base = ampersand_base.extend( base.prototype )
    base.extend = Skr.lib.CreateExtendsChain( ampersand_base, base )

    base
