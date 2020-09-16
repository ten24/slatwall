var clone = require('gulp-clone');
var concat = require('gulp-concat');
var gulp = require('gulp');
var merge = require('merge-stream');
var rename = require('gulp-rename');
var sass = require('gulp-sass');
var sourcemaps = require('gulp-sourcemaps');
var cssnano = require('gulp-cssnano');

gulp.task('styles', function(){
    var source = gulp.src('custom/client/assets/scss/app.scss')
                    .pipe(sourcemaps.init())
                    .pipe(sass().on('error', sass.logError))
                    .pipe(concat('style.css'));
            
    var nonMinified = source.pipe(clone())
                        .pipe(sourcemaps.write('.'))
                        .pipe(gulp.dest('custom/client/assets/css'));
            
    var minified = source.pipe(clone())
                        .pipe(cssnano())
                        .pipe(rename({suffix:'.min'}))
                        .pipe(sourcemaps.write('.'))
                        .pipe(gulp.dest('custom/client/assets/css'));
                        
    return merge( nonMinified, minified );
});


gulp.task('watch', function(){
    gulp.watch('custom/client/assets/scss/**/*.scss', gulp.series('styles'));
})