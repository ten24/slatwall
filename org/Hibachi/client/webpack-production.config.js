var WebpackStrip = require('strip-loader');
var devConfig = require('./webpack.config');

var stripLoader = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('console.log')
}
var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');
//extend and override the devconfig
devConfig.module.loaders.push(stripLoader);
devConfig.plugins= [
  	new ngAnnotatePlugin({
        add: true,
        // other ng-annotate options here 
    })
  ];
//change output filename
//devConfig.output.filename = "bundle.min.js";
module.exports = devConfig;