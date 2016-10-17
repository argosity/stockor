//=require lanes/remote/api
//=require ./api/namespace
//=require skr/vendor
//=require skr/lib/Remote
//=require ./api/Models/Base
//=require_tree ./models/mixins
//=require ./api/Components/Base
//=require ./api/Components/Base
//=require_tree ./api
//=require_self

Skr.lib.Remote.configFromScriptTag()

var previousSkr = window.Skr;
window.Skr = Lanes.Skr;

window.Skr._lanes = window.Lanes.noConflict();

Skr.noConflict = function(){
    var Skr = window.Skr;
    window.Skr = previousSkr;
    return Skr;
};
