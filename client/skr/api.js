//=require lanes/remote/api
//=require skr/vendor
//=require skr/lib/Remote
//=require ./api/all

//=require_self


var previousSkr = window.Skr;
window.Skr = Lanes.Skr;

Skr.lib.Remote.configFromScriptTag();

window.Skr._lanes = window.Lanes.noConflict();

Skr.noConflict = function(){
    var Skr = window.Skr;
    window.Skr = previousSkr;
    return Skr;
};
