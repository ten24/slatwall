let devConfig = require('./webpack.config');
const webpack = require('webpack');
const path = require('path');
const TerserPlugin = require("terser-webpack-plugin"); //minimizer

const PATHS = {
	clientRoot      :	__dirname ,
    clientSrc       :   path.join(__dirname, '/src'),
    monatFrontend   :	path.join(__dirname, '/src/monatfrontend'),
    hibachiSrc      : 	path.resolve(__dirname, '../../org/Hibachi/client/src'),
    nodeModeles     :   path.resolve(__dirname, '../../node_modules')
};


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
        mangle: false, // this will reduce the size of the bundles significently, but can cause problem with angular if components are not annotated properly
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
