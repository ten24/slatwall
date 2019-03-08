var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");
const CleanWebpackPlugin = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    dist: path.join(__dirname,'/dist'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    mode:'development',
    context:PATHS.app,
    entry: {
        bundle:['./bootstrap.ts']
    },
    watch:true,
    output: {
        path: PATHS.dist,
        filename: '[name].[contenthash].js',
        publicPath:'#request.slatwallScope.getBaseURL()#/admin/client/dist/'
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
      },
    plugins: [
        new webpack.HashedModuleIdsPlugin(), // so that file hashes don't change unexpectedly
        new HtmlWebpackPlugin({
          template:path.join(PATHS.app,'/template.html'),
          inject:false,
          templateParameters: function(compilation, assets, options) {
            return {
              files: assets,
              options: options,
              webpackConfig: compilation.options,
              webpack: compilation.getStats().toJson()
            }
          }
       }),
       // new CleanWebpackPlugin(['dist/*']) for < v2 versions of CleanWebpackPlugin
        new CleanWebpackPlugin(),
      ],
      optimization: {
        usedExports: true,
        runtimeChunk: 'single',
        splitChunks: {
          chunks: 'all',
          maxInitialRequests: Infinity,
          minSize: 0,
          /*cacheGroups: {
            vendor: {
              test: /[\\/]node_modules[\\/]/,
              name(module) {
                // get the name. E.g. node_modules/packageName/not/this/part.js
                // or node_modules/packageName
                const packageName = module.context.match(/[\\/]node_modules[\\/](.*?)([\\/]|$)/)[1];
    
                // npm package names are URL-safe, but some servers don't like @ symbols
                return `npm.${packageName.replace('@', '')}`;
              },
            },
          },*/
        },
      },
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