Skr.namespace "Templates"


ns2path = (ns)->
    ns.replace(".","/").toLowerCase()

Skr.Templates.find = (name, namespace) ->
    return Skr.Templates[name] if Skr.Templates[name]
    if namespace?
        Skr.Templates[ ns2path(namespace) + "/" + name]
    else
        nil

# scribbed from eco's compiler.coffee
# we include the functions here rather than on every single template
Skr.TemplateWrapper = {

    sanitize: (value) ->
        if value and value.HTMLSafe
            value
        else if typeof value isnt "undefined" and value?
            Skr.TemplateWrapper.escape value
        else
            ""

    capture: (__out) ->
        (callback) ->
            out = __out
            result = undefined
            __out = []
            callback.call this
            result = __out.join("")
            __out = out
            __safe result

    escape: Skr.u.escape

    safe: (value) ->
        if value and value.HTMLSafe
            value
        else
            value = ""  unless typeof value isnt "undefined" and value?
            result = new String(value)
            result.HTMLSafe = true
            result

}

#Skr.namespace( 'Templates' );

# Skr.Templates.find = function(name,namespace) {
#     if ( Skr.Templates[name] )
#         return  Skr.Templates[name];
#     return ( namespace || Skr.Templates[name] );
# }

# // scribbed from eco's compiler.coffee
# // we include the functions here rather than on every single template
# Skr.TemplateWrapper = {

#     sanitize: function(value) {
#         if (value && value.HTMLSafe) {
#             return value;
#         } else if (typeof value !== 'undefined' && value != null) {
#             return Skr.TemplateWrapper.escape(value);
#         } else {
#             return '';
#         }
#     },

#     capture: function(__out){
#         return function(callback) {
#             var out = __out, result;
#             __out = [];
#             callback.call(this);
#             result = __out.join('');
#             __out = out;
#             return __safe(result);
#         };
#     },

#     escape: Skr.u.escape,

#     safe: function(value) {
#         if (value && value.HTMLSafe) {
#             return value;
#         } else {
#             if (!(typeof value !== 'undefined' && value != null)) value = '';
#             var result = new String(value);
#             result.HTMLSafe = true;
#             return result;
#         }
#     }
# };
