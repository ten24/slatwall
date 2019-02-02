var devConfig = require('../../org/Hibachi/client/webpack.config');
var CompressionPlugin = require("compression-webpack-plugin");
var webpack = require('webpack');
var path = require('path');
var customPath = __dirname;
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};

if(typeof bootstrap !== 'undefined'){
    devConfig.entry.app[this.entry.app.length - 1] = bootstrap;
}
delete devConfig.entry.vendor; //remove the vendor info from this version.
devConfig.output.path = PATHS.app;
devConfig.context = PATHS.app;
//don't need the vendor bundle generated here because we include the vendor bundle already.
devConfig.plugins =  [
];   
module.exports = devConfig;