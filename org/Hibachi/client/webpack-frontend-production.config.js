//START NEW PROD
var devConfig = require('./webpack-frontend-develop.config');
	devConfig.entry.app = ['./frontend/bootstrap'];
    devConfig.output.filename = 'slatwall.js';
    
var CompressionPlugin = require("compression-webpack-plugin");
var ngAnnotatePlugin = require("ng-annotate-webpack-plugin");
var webpack = require('webpack');
var path = require('path');
var customPath = __dirname;
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};

delete devConfig.entry.vendor; //remove the vendor info from this version.
devConfig.output.path = PATHS.app;
devConfig.context = PATHS.app;
devConfig.watch = false;
//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    new webpack.DefinePlugin({
          'process.env': {
            'NODE_ENV': JSON.stringify('production')
          }
    }),
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
module.exports = devConfig;

