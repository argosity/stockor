//= require_self
//= require_tree .

Skr.Templates = Skr.Templates || {};

String.prototype.HTMLSafe=false;

// scribbed from eco's compiler.coffee
// we have the functions here rather than on every single
// template
Skr.TemplateWrapper = {

    sanitize: function(value) {
        if (value && value.HTMLSafe) {
            return value;
        } else if (typeof value !== 'undefined' && value != null) {
            return Skr.TemplateWrapper.escape(value);
        } else {
            return '';
        }
    },

    capture: function(__out){
        return function(callback) {
            var out = __out, result;
            __out = [];
            callback.call(this);
            result = __out.join('');
            __out = out;
            return __safe(result);
        };
    },

    escape: Skr.u.escape,

    safe: function(value) {
        if (value && value.HTMLSafe) {
            return value;
        } else {
            if (!(typeof value !== 'undefined' && value != null)) value = '';
            var result = new String(value);
            result.HTMLSafe = true;
            return result;
        }
    }
};
