Skr.View.Assets = {
    path: (asset)->
        path = @paths[ asset ]
        Skr.log( "Path for #{asset} was not found" ) unless path
        path

    setPaths: (paths={})->
        @paths = paths;
}