//=require lanes/Remote/Bootstrap
//=require_self

window.Skr = (window.Skr || {});
window.Skr.loading = Lanes.Remote.Bootstrap({
    srcTag: 'skr/api.js',
    scripts: {
        js:  'skr/api/full.js',
        css: 'skr/api/full.css'
    }
});


window.Skr.loading.onComplete(function(){
    var previousSkr = window.Skr;
    var loading = window.Skr.loading;
    window.Skr = Lanes.Skr;
    window.Skr.loading = loading;

    window.Skr._lanes = window.Lanes.noConflict();

    Skr.noConflict = function(){
        var Skr = window.Skr;
        window.Skr = previousSkr;
        return Skr;
    };
});
