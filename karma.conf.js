// Karma configuration
// Generated on Sat Dec 16 2017 15:46:16 GMT-0500 (EST)

var path = require('path');
var customPath = __dirname;

var webpackConfig = require('./admin/client/webpack-test.config.js');
webpackConfig.entry = "";
delete webpackConfig.plugins;
module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ["jasmine", "karma-typescript"],

    webpack: webpackConfig,
	
	mime: {
  		'text/x-typescript': ['ts']
	},
	
    // list of files / patterns to load in the browser
    files: [
      './org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js',
      './org/Hibachi/HibachiAssets/js/jquery-ui.min.js',
      './org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js',
      './org/Hibachi/HibachiAssets/js/bootstrap.min.js',
      './org/Hibachi/HibachiAssets/js/hibachi-scope.js',
      './org/Hibachi/HibachiAssets/js/hibachi-scope-test.js',
      './assets/js/admin.js',
      './org/Hibachi/HibachiAssets/js/global.js',
      './org/Hibachi/client/lib/angular/angular.js',
       './org/Hibachi/client/lib/angular/angular-mocks.js',
      './org/Hibachi/client/src/vendor.bundle.js',
      { pattern: "./org/Hibachi/client/src/**/*.ts" },
      { pattern: "./admin/client/src/**/*.ts" },
      './admin/client/src/bundle.js',
      './org/Hibachi/client/src/bundle.js',
      
      ],


    // list of files to exclude
    exclude: [
     "./node_modules/*",
     "./org/Hibachi/client/typings/*.ts"
    ],
	
	// now setup the compiler options
	karmaTypescriptConfig: {
		compilerOptions: {
	       "target":"es5",
	    	"module": "commonjs",
	    	"sourceMap": true
	    },
	     "files": [
		    "./admin/client/typings/slatwallTypescript.d.ts",
		    "./admin/client/typings/tsd.d.ts"
		],
	    tsconfig: './admin/client/tsconfig.json'
    },

    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
	  './admin/client/src/testbundle.js': ['webpack'],
	  './org/Hibachi/client/src/**/*.ts':['karma-typescript'],
	  './admin/client/src/**/*.ts':['karma-typescript'],
	   "**/*.html": ['ngbootstrapfix']
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ["progress", "karma-typescript", "spec", "html"],
	
	karmaTypescriptConfig: {
	    reports:
	    {
	        "html": "./meta/tests/unit/client/coverage",
	        "text-summary": ""
	    }
	},
	
	htmlReporter: {
      outputFile: './meta/tests/unit/client/units.html',
            
      // Optional 
      pageTitle: 'Slatwall Unit Tests',
      subPageTitle: 'Angularjs Typescript Unit Tests',
      groupSuites: true,
      useCompactStyle: true,
      useLegacyStyle: false
    },

    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_DISABLE,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome'],
    /*browsers: ['PhantomJS'],
	
	phantomjsLauncher: {
      // Have phantomjs exit if a ResourceError is encountered (useful if karma exits without killing phantom)
      exitOnResourceError: true
    },*/

    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false,

    // Concurrency level
    // how many browser should be started simultaneous
    concurrency: Infinity
  })
}
