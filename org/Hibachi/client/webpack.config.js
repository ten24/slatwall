const webpack = require('webpack');
const WebpackBar = require('webpackbar');
const CompressionPlugin = require("compression-webpack-plugin");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    context     :PATHS.lib,
    mode        : 'development',
    devtool     : 'source-map',
    watch       :true,
	entry: {
        vendor : ["./vendor.ts"],
    },
    output: {
        path: PATHS.app, // we should create another dist folder here
        filename: (pathData) => {
            // Use pathData object for generating filename string based on your requirements
            return `${pathData.chunk.name}.bundle.js`;
        },
        library: 'hibachi'
    },

    resolve: {
        extensions: ['.webpack.js', '.web.js', '.ts', '.js','.html'],
        alias: {

        }
    },
    module: {
    	noParse: [ /bower_components/ ],
	    rules: [
	      // all files with a `.ts` or `.tsx` extension will be handled by `ts-loader`
	      { test: /\.tsx?$/, loader: 'ts-loader' }
	    ]
	},
	optimization: {
        splitChunks: {
            cacheGroups: {
                vendor : {
                    filename: "vendor.bundle.js"
                }
            }
        }
	},
	plugins :  [

        new CompressionPlugin({
          test: /\.(j|c)ss?$/i,
          threshold: 10240,
          filename: '[path].gz[query]',
          deleteOriginalAssets: false
        }),
        
        // HTTPS only
        // https://webpack.js.org/plugins/compression-webpack-plugin/#using-brotli
        // brotli is much smaller
        new CompressionPlugin({
          test: /\.(j|c)ss?$/i,
          filename: '[path].br[query]',
          algorithm: 'brotliCompress',
          threshold: 10240,
          minRatio: 0.8,
          compressionOptions: {
            // zlib’s `level` option matches Brotli’s `BROTLI_PARAM_QUALITY` option.
            level: 11,
          },
          deleteOriginalAssets: false,
        }),
    
        new WebpackBar({
            name: "Hibachi: vendor",
            reporters: [ 'basic', 'fancy', 'profile', 'stats' ],
            fancy: true,
            profile: false,
            stats: true,
        })
    ]
};

module.exports = appConfig;