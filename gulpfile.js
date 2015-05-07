var gulp = require('gulp'),
    traceur = require('gulp-traceur'),
    to5 = require('gulp-6to5'),
    plumber = require('gulp-plumber'),
    rename = require('gulp-rename'),
    uglify = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps'),
    concat = require('gulp-concat'),
    gzip = require('gulp-gzip'),
    properties = require ("properties"),
    fs = require('fs'),
    debug = require('gulp-debug'),
    inject = require('gulp-inject'),
    tsc = require('gulp-typescript'),
    tslint = require('gulp-tslint'),
    rimraf = require('gulp-rimraf');
	Config = require('./gulpfile.config'),
	request = require('request'),
	chmod = require('gulp-chmod'),
	runSequence = require('run-sequence'),
	changed = require('gulp-changed');

	var config = new Config();
	
/*
gulp.task('properties2json',function(){
	//get all files in a directory
	var dir = 'config/resourceBundles';
    var results = [];
    fs.readdirSync(dir).forEach(function(file) {
        file = dir+'/'+file;
        properties.parse(file,{path:true}, function (error, obj){
        	if (error) return console.error (error);
        	var newobj = {};
        	for(key in obj){
        		newobj[key.toLowerCase()] = obj[key];
        	}
        	var newfile = file.replace('.properties','.json');
        	
        	if(fs.existsSync(newfile)){
        		fs.unlink(newfile, function (err) {
    				console.log(err);
        		  if (err) throw err;
        		  console.log('successfully deleted '+newfile);
        		  	fs.writeFile(newfile, JSON.stringify(newobj), function(){
              			console.log('It\'s saved!');
              		});
        		});
        	}else{
        		fs.writeFile(newfile, JSON.stringify(newobj), function(){
            		console.log('It\'s saved!');
            	});
        	}
	  	});
    });
});*/

gulp.task('watch', function() {
	//gulp.watch([config.ngSlatwallcfm],['flattenNgslatwall']);
    gulp.watch([config.allTypeScript], 
    [
    	'compile-ts'
		,'gen-ts-refs'
		
		//,'compress'
	]);
	gulp.watch([config.es6Path],
	[
		'traceur'
	]);
    //gulp.watch([config.es6Path],['traceur']);
    //gulp.watch([config.es5Path],['compress']);
    //gulp.watch([propertiesPath],['properties2json']);
});


/**
 * Lint all custom TypeScript files.
 */
gulp.task('ts-lint', function () {
    return gulp.src(config.allTypeScript).pipe(tslint()).pipe(tslint.report('prose'));
});

/**
 * Compile TypeScript and include references to library and app .d.ts files.
 */
gulp.task('compile-ts', function () {
	var sourceTsFiles = [config.allTypeScript,                //path to typescript files
                         config.libraryTypeScriptDefinitions, //reference to library .d.ts files
                         config.appTypeScriptReferences];     //reference to app.d.ts files

    var tsResult = gulp.src(sourceTsFiles)
    					.pipe(changed(config.tsOutputPath))
                       .pipe(sourcemaps.init())
                       .pipe(tsc({
                           target: 'ES6',
                           declarationFiles: false,
                           noExternalResolve: true
                       }));

        tsResult.dts.pipe(gulp.dest(config.tsOutputPath));
        return tsResult.js
        				
                        .pipe(sourcemaps.write('.'))
                        .pipe(chmod(777))
                        .pipe(gulp.dest(config.tsOutputPath));
});

gulp.task('gen-ts-refs', function () {
	setTimeout(function () {
	    var target = gulp.src(config.appTypeScriptReferences);
	    var sources = gulp.src([config.allTypeScript], {read: false});
	     return target.pipe(inject(sources, {
	        starttag: '//{',
	        endtag: '//}',
	        transform: function (filepath) {
	            return '/// <reference path="../..' + filepath + '" />';
	        }
	    }))
	    .pipe(chmod(777))
	    .pipe(gulp.dest(config.typings));
	},0);
});

gulp.task('compile-ngslatwall-ts',function(){
	var sourceTsFiles = [config.ngSlatwallTypescript
	];   

    var tsResult = gulp.src(sourceTsFiles)
    					
                       .pipe(sourcemaps.init())
                       .pipe(tsc({
                           target: 'ES6',
                           declarationFiles: false,
                           noExternalResolve: true
                       }));

        tsResult.dts.pipe(gulp.dest(config.ngSlatwallOutputPath));
        return tsResult.js
        				
                        .pipe(sourcemaps.write('.'))
                        .pipe(chmod(777))
                        .pipe(gulp.dest(config.ngSlatwallOutputPath));
});

/**
 * Remove all generated JavaScript files from TypeScript compilation.
 */
gulp.task('clean-ts', function () {
  var typeScriptGenFiles = [config.tsOutputPath,            // path to generated JS files
                            config.tsOutputPath +'**/*.js',    // path to all JS files auto gen'd by editor
                            config.tsOutputPath +'**/*.js.map' // path to all sourcemap files auto gen'd by editor
                           ];

  // delete the files
  return gulp.src(typeScriptGenFiles, {read: false})
      .pipe(rimraf());
});

gulp.task('flattenNgslatwall',function(){
	var makeid = function()
	{
	    var text = "";
	    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	
	    for( var i=0; i < 5; i++ )
	        text += possible.charAt(Math.floor(Math.random() * possible.length));
	
	    return text;
	}
	
	request('http://cf10.localhost/?slatAction=api:js.ngslatwall&reload=true&instantiationKey='+makeid(), function (error, response, body) {
	  if (!error && response.statusCode == 200) {
		  var dir = 'admin/client/ts/modules/';
		  var newFile = dir+'ngslatwall.ts';
		  fs.writeFile(newFile, body, function(){
      		console.log('It\'s saved!');
		  });
	  }else{
	  	console.log(error);
	  }
	});
});

gulp.task('traceur', function () {
  return gulp.src([config.es6Path])
		.pipe(changed(config.compilePath))
  	  .pipe(sourcemaps.init())
      .pipe(plumber())
      .pipe(traceur({ blockBinding: true }))
      .pipe(chmod(777))
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('./' + config.compilePath + '/es5'));
});

gulp.task('6to5', function () {
   return gulp.src([config.es6Path])
   	.pipe(changed(config.compilePath))
   	.pipe(sourcemaps.init())
      .pipe(plumber())
      .pipe(to5())
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('./' + config.compilePath + '/es5'));
});

gulp.task('compress',function(){
    gulp.src([
      config.compilePath + 'es5/modules/ngslatwall.js',
      config.compilePath + 'es5/modules/slatwalladmin.js',
      config.compilePath + 'es5/services/*.js',
      config.compilePath + 'es5/controllers/**/*.js',
      config.compilePath + 'es5/directives/**/*.js'
    ])
  .pipe(sourcemaps.init())
  .pipe(concat('all.js'))
  .pipe(uglify({
      compress: {
          negate_iife: false
      },
      parse:{
      	strict:true
      }
  }))
  .pipe(rename(function(path){
      path.extname = '.min.js'
  }))
  .pipe(sourcemaps.write('./'))
  .pipe(chmod(777))
  .pipe(gulp.dest('./' + config.compilePath + 'es5'));
});

gulp.task('default', function(){
	runSequence(
		'compile-ts'
		,'gen-ts-refs'
		,'traceur'
		//,'compress'
		,'watch'
	);
});