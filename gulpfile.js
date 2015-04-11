var gulp = require('gulp'),
    traceur = require('gulp-traceur'),
    to5 = require('gulp-6to5'),
    plumber = require('gulp-plumber'),
    typeScriptPath = 'admin/client/ts/**/*.ts',
    compilePath = 'admin/client/js/',
    es5Path = 'admin/client/js/es5/**/*.js',
    rename = require('gulp-rename'),
    uglify = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps'),
    concat = require('gulp-concat'),
    gzip = require('gulp-gzip');

gulp.task('traceur', function () {
  gulp.src([typeScriptPath])
      .pipe(rename(function (path) {
          path.dirname = path.dirname.replace('/ts/','/js/'),
          path.extname = '.js'
      }))
      .pipe(plumber())
      .pipe(traceur({ blockBinding: true }))
      .pipe(gulp.dest('./' + compilePath + '/es6'));
});

gulp.task('6to5', function () {
    gulp.src([typeScriptPath])
      .pipe(plumber())
      .pipe(to5())
      .pipe(rename(function (path) {
          path.dirname = path.dirname.replace('/ts/','/js/'),
          path.extname = '.js'
      }))
      .pipe(gulp.dest('./' + compilePath + '/es5'));
});

gulp.task('compress', ['traceur', '6to5'],function(){
  setTimeout(function () {
    gulp.src([
      compilePath + 'es5/modules/**/*.js',
      compilePath + 'es5/services/**/*.js',
      compilePath + 'es5/controllers/**/*.js',
      compilePath + 'es5/directives/**/*.js'
    ])
      .pipe(sourcemaps.init())
      .pipe(concat('all.js'))
      .pipe(uglify({
          compress: {
              negate_iife: false
          }
      }))
     
      .pipe(rename(function(path){
          path.extname = '.min.js'
      }))
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('./' + compilePath + 'es5'));

      gulp.src([
        compilePath + 'es6/modules/**/*.js',
        compilePath + 'es6/services/**/*.js',
        compilePath + 'es6/controllers/**/*.js',
        compilePath + 'es6/directives/**/*.js'
      ])
      .pipe(sourcemaps.init())
      .pipe(concat('all.js'))
      .pipe(uglify({
          compress: {
              negate_iife: false
          }
      }))
      
      .pipe(rename(function(path){
          path.extname = '.min.js'
      }))
      .pipe(sourcemaps.write('./'))
      .pipe(gulp.dest('./' + compilePath + 'es6'));
    },1000);
});

gulp.task('watch', function() {
    gulp.watch([typeScriptPath], ['compress']);
});

gulp.task('default', ['compress', 'watch']);