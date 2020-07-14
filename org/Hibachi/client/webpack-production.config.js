var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");

var appConfig = require("./webpack.config.js");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};
appConfig.watch=false;
appConfig.context=PATHS.app;
appConfig.devtool= 'source-map';
appConfig.module.rules=[
    {
        test: /\.ts?$/,
        loader: 'ng-annotate-loader?ngAnnotate=ng-annotate-patched!ts-loader'
    }
];
appConfig.plugins =  [
    new ForceCaseSensitivityPlugin(),
    new webpack.ContextReplacementPlugin(/moment[/\\]locale$/, /us/),
        new webpack.optimize.CommonsChunkPlugin({name:"vendor", filename:"vendor.bundle.js"}),
	    new CompressionPlugin({
	      asset: "[path].gz[query]",
	      algorithm: "gzip",
	      test: /\.js$|\.css$|\.html$/,
	      threshold: 10240,
	      minRatio: 0.8
	    }),
	    new webpack.optimize.AggressiveMergingPlugin(),//Merge chunks
	    new webpack.optimize.OccurrenceOrderPlugin(),
	    new webpack.optimize.UglifyJsPlugin({
	    mangle: false,
	    minimize: true,
	    sourceMap:true,
		    compress: {
	         // remove warnings
	            warnings: false,
	
	         // Drop console statements
	            drop_console: true
	       },
		    output: {
	        	comments: false
	    	}
		})
];

    
    
; 
module.exports = appConfig;