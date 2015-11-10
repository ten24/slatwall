var webpack = require('webpack');  
//var angular = require('angular');
var path = require('path');
var PATHS = {
    app:__dirname + '/src/hibachi'
};
var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');
module.exports = {  
  context:PATHS.app,
  entry: {
    app:'./core/bootstrap.ts'
  },
  output: {
    path: PATHS.app,
    filename: 'bundle.js'
  },
  // Turn on sourcemaps
  devtool: 'source-map',
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.ts', '.js'],
    alias:{
  		//'angular':'../../../lib/angular/angular.min.js'
  		//,'ui.bootstrap':'../../lib/angular-ui-bootstrap/ui.bootstrap.min.js'
  		//,'angular-resource':'../../lib/angular/angular-resource.min.js'
  		//,'angular-cookies':'../../lib/angular/angular-cookies.min.js'
  		//,'logging':'./modules/logger/logger.ts'
  	}
  },
  
  // Add minification
  plugins: [
  	new ngAnnotatePlugin({
        add: true,
        // other ng-annotate options here 
    })
    //,new webpack.optimize.UglifyJsPlugin()
  ],
  module: {
    loaders: [
      { 
      	test: /\.ts$/, loader: 'ts-loader',
      	exclude: /node_modules/ 
      }
    ],
  }
}