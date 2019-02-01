//webpack --config webpack-production.config.js -p

var WebpackStrip = require('strip-loader'),
    devConfig = require('./webpack-frontend-develop.config'),
    ngAnnotatePlugin = require('ng-annotate-webpack-plugin');


devConfig
    .addLoader({exlude: /node_modules/, loader: WebpackStrip.loader('console.log')})
    .addLoader({ exlude: /node_modules/,  loader: WebpackStrip.loader('$log.debug') })
    .addPlugin(new ngAnnotatePlugin({ add: true }))
;
devConfig.watch = false;

module.exports = devConfig; 

