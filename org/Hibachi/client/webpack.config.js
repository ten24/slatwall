var webpack = require('webpack');  
var path = require('path');
var PATHS = {
    app:__dirname + '/src'
};

module.exports = {  
  context:PATHS.app,
  entry: {
    app:'./bootstrap.ts'
  },
  watch:true,
  output: {
    path: PATHS.app,
    filename: 'bundle.js'
  },
  // Turn on sourcemaps
  //devtool: 'source-map',
  resolve: {
    extensions: ['', '.webpack.js', '.web.js', '.ts', '.js'],
    //previous scripts loaded
     alias:{
    	'date':'../lib/date/date.min.js'
  		,'angular':'../lib/angular/angular.min.js'
  		,'angular-lazy-bootstrap':'../lib/angular-lazy-bootstrap/bootstrap.js'
  		,'ui.bootstrap':'../lib/angular-ui-bootstrap/ui.bootstrap.min.js'
  		,'angular-resource':'../../lib/angular/angular-resource.min.js'
  		,'angular-cookies':'../../lib/angular/angular-cookies.min.js'
  		,'angular-route':'../lib/angular/angular-route.min.js'
        ,'angular-animate':'../lib/angular/angular-animate.min.js'
        ,'angular-sanitize':'../lib/angular/angular-sanitize.min.js'
        ,'metismenu':'../lib/metismenu/metismenu.js'
      //,'ng-ckeditor':'../lib/ng-ckeditor/ng-ckeditor.min.js'
  	}
  },
  
  
  module: {
    noParse: [ /bower_components/ ],
    loaders: [
      { 
      	test: /\.ts$/, loader: 'ts-loader',
      	exclude: /node_modules/ 
      }
    ],
  }
}