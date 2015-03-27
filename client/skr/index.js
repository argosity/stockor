//=require ./models/Base
//=require ./views/Base
//=require_tree ./models/mixins
//=require_tree ./models
//=require_tree ./views
//=require_tree ./components
//=require ./screens/Base
//=require ./screens/mixins
//=require ./Extension

/*
 Files located in the above directories are part of the default
 Javascript build and are downloaded to the client on the initial
 request.

 Accordingly, only essential files should be included here. Code that
 relates to a screen should be placed in the "screens" directory,
 where it will be loaded dynamically when the screen is displayed.

 Alternatively, feel free to modify the require statements above to
 only include the paths you need.
 */
