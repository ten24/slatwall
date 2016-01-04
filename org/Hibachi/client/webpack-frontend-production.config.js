//webpack --config webpack-production.config.js -p
var slatwallAngular = {
    slatwallConfig:{
        baseUrl:'/'
    }
};
var WebpackStrip = require('strip-loader');
var devConfig = require('./webpack-frontend-develop.config');

var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');

var stripConsolelogs = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('console.log')
}
//extend and override the devconfig
devConfig.module.loaders.push(stripConsolelogs);

var stripLogDebugs = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('$log.debug')
}
//extend and override the devconfig
devConfig.module.loaders.push(stripLogDebugs);

devConfig.plugins= [
  	new ngAnnotatePlugin({
        add: true,
        // other ng-annotate options here 
    })
  ];
//change output filename

module.exports = devConfig; 

