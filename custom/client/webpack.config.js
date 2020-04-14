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
devConfig.output.filename = 'monat.js';
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
devConfig.resolve.modules= [
    path.resolve(path.join(customPath, './'), 'src/'),
    path.resolve(path.join(customPath, '../../admin/client'), 'src/'),
    path.resolve(path.join(customPath, '../../client'), 'src/'),
    path.resolve(__dirname, 'src/'),
    'node_modules'
];

devConfig.resolve.alias =  {
      '@Monat': path.resolve(path.join(customPath, './'), 'src/monatfrontend/')
};

module.exports = devConfig;
