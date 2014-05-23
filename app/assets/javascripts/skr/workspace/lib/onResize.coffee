this.listenTo($(window),"resize", this.resizeContext, this));

resizeContext: function(event) {

            console.log("resizing context for "+this.id);

            this.setHeight();

            // trigger resize event (use event bus)
            this.options.vent.trigger("resize", event);

        }

var SomeView = Backbone.View.extend({
  initialize:function() {
    $(window).on("resize",this.resizeContext)
  },

  remove: function() {
    $(window).off("resize",this.resizeContext);
    //call the superclass remove method
    Backbone.View.prototype.remove.apply(this, arguments);
  }
});

/**
 * Use Backbone Events listenTo/stopListening with any DOM element
 *
 * @param {DOM Element}
 * @return {Backbone Events style object}
 **/
function asEvents(el) {
    var args;
    return {
        on: function(event, handler) {
            if (args) throw new Error("this is one off wrapper");
            el.addEventListener(event, handler, false);
            args = [event, handler];
        },
        off: function() {
            el.removeEventListener.apply(el, args);
        }

    };
}

view.listenTo(asEvents(window), "resize", handler);