var devConfig = require('../../org/Hibachi/client/webpack.config');
var CompressionPlugin = require("compression-webpack-plugin");
var webpack = require('webpack');
var path = require('path');
var customPath = __dirname;
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};
devConfig.entry.app="./main.ts";
if(typeof bootstrap !== 'undefined'){
    devConfig.entry.app[this.entry.app.length - 1] = bootstrap;
}
delete devConfig.entry.vendor; //remove the vendor info from this version.
devConfig.output.path = PATHS.app;
devConfig.context = PATHS.app;
devConfig.watch = false;
//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    // Workaround for https://github.com/angular/angular/issues/11580
    new webpack.ContextReplacementPlugin(
      // The (\\|\/) piece accounts for path separators in *nix and Windows
      /angular(\\|\/)core(\\|\/)(@angular|esm5)/,
      path.resolve(__dirname, '../src')
    ),
    
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
