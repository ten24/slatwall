var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    context:PATHS.app,
    entry: {
        app:['./bootstrap.ts'],
         vendor: ["../lib/vendor.ts"],
    },
    watch:true,
    output: {
        path: PATHS.app,
        filename: 'bundle.js',
        library: 'hibachi'
    },
    // Turn on sourcemaps
    //devtool: 'source-map',
    resolve: {
        extensions: ['.webpack.js', '.web.js', '.ts', '.js']
    },
    module: {
    	noParse: [ /bower_components/ ],
	    rules: [
	      // all files with a `.ts` or `.tsx` extension will be handled by `ts-loader`
	      { test: /\.tsx?$/, loader: 'ts-loader' }
	    ]
	},
    plugins: [
        new webpack.optimize.CommonsChunkPlugin({name:"vendor", filename:"vendor.bundle.js"})
    ]

};

module.exports = appConfig;