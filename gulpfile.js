
/*  */
var gulp = require('gulp'),
Config = require('./gulpfile.config'),
  //   traceur = require('gulp-traceur'),
  //   to5 = require('gulp-6to5'),
  //   plumber = require('gulp-plumber'),
  //   rename = require('gulp-rename'),
  //   uglify = require('gulp-uglify'),
  //   sourcemaps = require('gulp-sourcemaps'),
  //   concat = require('gulp-concat'),
  //   fs = require('fs'),
  //   debug = require('gulp-debug'),
     inject = require('gulp-inject'),
  //   tsc = require('gulp-typescript'),
  //   tslint = require('gulp-tslint'),
  //   rimraf = require('gulp-rimraf');
	// Config = require('./gulpfile.config'),
	// request = require('request'),
	 chmod = require('gulp-chmod'),
	 runSequence = require('run-sequence'),
	//  ngmin = require("gulp-ngmin"),
	// changed = require('gulp-changed');
	// ngAnnotate = require('gulp-ng-annotate');
  gutil = require('gutil'),
  webpack = require('webpack'),
  webpackConfig = require('./org/Hibachi/client/webpack.config');
  

	
	var config = new Config();
	

gulp.task('watch', function() {
	
    gulp.watch([config.allTypeScript], 
    [
    	
		'gen-ts-refs',
    'runwebpack'
		
	]);
	
});

gulp.task('gen-ts-refs', function () {
 
	setTimeout(function () {
	    var target = gulp.src(config.appTypeScriptReferences);
	    var sources = gulp.src([
        config.allTypeScript
      ], {read: false});
	     return target.pipe(inject(sources, {
	        starttag: '//{',
	        endtag: '//}',
	        transform: function (filepath) {
	        	
	            return '/// <reference path="' + filepath.replace('/org/Hibachi/client/','../') + '" />';
	        }
	    }))
	    .pipe(chmod(777))
	    .pipe(gulp.dest(config.typings));
	},0);
});

gulp.task('runwebpack',function(){
  var myConfig = Object.create(webpackConfig);
  
  webpack(myConfig, function(err, stats) {
        if(err) throw new gutil.PluginError("webpack", err);
        gutil.log("[webpack]", stats.toString({
            // output options
        }));
        //callback();
    });
});

gulp.task('default', function(){
  runSequence(
		'gen-ts-refs',
    'runwebpack',
    'watch'
  );
});
