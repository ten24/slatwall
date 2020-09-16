// var path = require('path');
var gulp = require('gulp');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');

gulp.task('default', function() {
	gulp.start('scss-theme');
});

gulp.task('theme', function() {
	gulp.start('scss-theme');
});

gulp.task('watch', function() {
	gulp.watch('assets/scss/**/*.scss', ['scss-theme']);
});

gulp.task('scss-theme', function() {
	gulp.src('assets/scss/site/**/*.scss')
		.pipe(sass().on('error', sass.logError))
		.pipe(autoprefixer({
			browsers: ['last 2 versions'],
			cascade: false
		}))
		.pipe(gulp.dest('css/'));
});

function swallowError (error) {
	console.log(error.toString());
	this.emit('end');
}
