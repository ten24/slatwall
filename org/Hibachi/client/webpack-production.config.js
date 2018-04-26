var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');
var CompressionPlugin = require("compression-webpack-plugin");

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    context:PATHS.app,
    entry: {
        app:['./bootstrap.ts'],
         vendor: ["date", "angular", 'angular-lazy-bootstrap', 'ui.bootstrap', 'angular-resource', 'angular-cookies', 'angular-route',
         'angular-animate','angular-sanitize','metismenu','angularjs-datetime-picker','jquery-typewatch','jquery-timepicker'],
    },
    watch:false,
    output: {
        path: PATHS.app,
        filename: 'bundle.js',
        library: 'hibachi'
    },
    // Turn on sourcemaps
    //devtool: 'source-map',
    resolve: {
        extensions: ['.webpack.js', '.web.js', '.ts', '.js'],
         alias: {
            'date': '../lib/date/date.min.js',
            'angular': '../lib/angular/angular.min.js',
            'angular-lazy-bootstrap':'../lib/angular-lazy-bootstrap/bootstrap.js',
            'ui.bootstrap':'../lib/angular-ui-bootstrap/ui.bootstrap.min.js',
            'angular-resource':'../lib/angular/angular-resource.min.js',
            'angular-cookies':'../lib/angular/angular-cookies.min.js',
            'angular-route':'../lib/angular/angular-route.min.js',
            'angular-animate':'../lib/angular/angular-animate.min.js',
            'angular-sanitize':'../lib/angular/angular-sanitize.min.js',
            'metismenu':'../lib/metismenu/metismenu.js',
            'angularjs-datetime-picker':'../lib/angularjs-datetime-picker/angularjs-datetime-picker.js',
            'jquery-typewatch':'../../HibachiAssets/js/jquery-typewatch-2.0.js',
            'jquery-timepicker':'../../HibachiAssets/js/jquery-ui-timepicker-addon-1.3.1.js'
        },
    },
    module: {
    	noParse: [ /bower_components/ ],
	    rules: [
	      // all files with a `.ts` or `.tsx` extension will be handled by `ts-loader`
	      { test: /\.tsx?$/, loader: 'ts-loader' }
	    ]
	},
    plugins: [
        new ForceCaseSensitivityPlugin(),
        new webpack.optimize.CommonsChunkPlugin({name:"vendor", filename:"vendor.bundle.js"}),
	    new CompressionPlugin({
	      asset: "[path].gz[query]",
	      algorithm: "gzip",
	      test: /\.js$|\.css$|\.html$/,
	      threshold: 10240,
	      minRatio: 0.8
	    }),
	    new webpack.optimize.AggressiveMergingPlugin(),//Merge chunks
	    new webpack.optimize.OccurrenceOrderPlugin(),
	    new webpack.optimize.UglifyJsPlugin({
		    mangle: false,
		    minimize: true,
		    compress: {
	         // remove warnings
	            warnings: false,
	
	         // Drop console statements
	            drop_console: true
	       },
		    output: {
	        	comments: false
	    	}
		})
    ]

};
    
    
; 
module.exports = appConfig;
