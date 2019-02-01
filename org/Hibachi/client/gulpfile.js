
/*  */
var gulp = require('gulp'),
Config = require('./gulpfile.config'),
inject = require('gulp-inject'),
chmod = require('gulp-chmod'),
runSequence = require('run-sequence'),
gutil = require('gulp-util'),
webpack = require('webpack'),
webpackConfig = require('./webpack.config');

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

	            return '/// <reference path="..' + filepath + '" />';
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
    'runwebpack'
  );
});
