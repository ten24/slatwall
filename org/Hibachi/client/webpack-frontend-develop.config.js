//example usage: webpack --config webpack-frontend-develop.config.js


//new
//START NEW
var devConfig = require('./webpack.config');
	devConfig.entry.app = ['./frontend/bootstrap.ts'];
    devConfig.output.filename = 'slatwall.js';
    devConfig.watch = true;
var CompressionPlugin = require("compression-webpack-plugin");
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
//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
    new CompressionPlugin({
      asset: "[path].gz[query]",
      algorithm: "gzip",
      test: /\.js$|\.css$|\.html$/,
      threshold: 10240,
      minRatio: 0.8
    }),
    new webpack.optimize.OccurrenceOrderPlugin()
];   
module.exports = devConfig;