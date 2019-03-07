var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    mode:'development',
    context:PATHS.app,
    entry: {
        bundle:['./bootstrap.ts'],
        vendor:['../lib/vendor.ts']
    },
    watch:true,
    output: {
        path: PATHS.app,
        filename: '[name].js',
        chunkFilename: '[name].bundle.js'
    },
    // Turn on sourcemaps
    //devtool: 'source-map',
    resolve: {
        extensions: ['.webpack.js', '.web.js', '.ts', '.js']
    },
    module: {
        rules: [
          {
            test: /\.tsx?$/,
            use: [
              {
                loader: 'ts-loader',
                options: {
                  transpileOnly: true
                }
              }
            ]
          }
        ]
      }
    /*plugins: [
        new webpack.optimize.CommonsChunkPlugin({name:"vendor", filename:"vendor.bundle.js"})
    ]*/
    /*optimization: {
        splitChunks: {
            chunks: 'async',
            minSize: 30000,
            maxSize: 300000,
            minChunks: 1,
            maxAsyncRequests: 5,
            maxInitialRequests: 3,
            automaticNameDelimiter: '~',
            name: true,
            cacheGroups: {
                vendors: {
                  filename: '[name].bundle.js'
                }
            }
        }
    }*/
   

};

module.exports = appConfig;