var fs      = require('fs');
var path    = require('path');
var webpack = require("webpack");

var ENTRIES = {
    index: "./vendor.js"
}

module.exports = {
    cache: false,
    entry: ENTRIES,
    output: {
        path: path.join(__dirname, "../client/skr/vendor"),
        filename: "[name].js"
    },
    module: {
        loaders: [
            { test: /\.scss$/, loader: 'style!css!sass?includePaths[]=./node_modules'  },
            { test: /\.coffee$/, loader: "coffee" }
        ]
    },
    resolve: {
        extensions: ["", ".scss", ".coffee", ".js"]
    }
};
