var WebpackStrip = require('strip-loader');
var devConfig = require('./webpack.config');
var stripLoader = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('console.log')
}
//extend and override the devconfig
devConfig.module.loaders.push(stripLoader);
//change output filename
//devConfig.output.filename = "bundle.min.js";
module.exports = devConfig;