let devConfig = require('./webpack.config');
const webpack = require('webpack');
const TerserPlugin = require("terser-webpack-plugin"); //minimizer

devConfig.mode = 'production';
devConfig.devtool = 'none';

devConfig.optimization.minimizer = [
  new TerserPlugin({
    cache: true,
    parallel: true,
    extractComments: false,// will extract licenses
    terserOptions: {
        warnings: false,
        parse: {},
        compress: {
            drop_console: true, 
        },
        mangle: false, // this will reduce the size of the bundles significantly, but can cause problem with angular if components are not annotated properly
        module: false,
        output: {
            comments: false
        },
        toplevel: false,
        nameCache: null,
        ie8: true,
        keep_classnames: false,
        keep_fnames: false,
        safari10: true
    }
  })
];


module.exports = devConfig;
