var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    context     :PATHS.app,
    mode        : 'development',
    devtool     : 'source-map',
    watch       :true,
	entry: {
        vendor  : ["../lib/vendor.ts"],
    },
    output: {
        path: PATHS.app,
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
	}
};

module.exports = appConfig;