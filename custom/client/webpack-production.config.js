var devConfig = require('./webpack.config');
var CompressionPlugin = require("compression-webpack-plugin");
var webpack = require('webpack');

devConfig.devtool= 'none';

//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    
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
