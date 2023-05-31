
var gulp = require('gulp'),
	babel = require('gulp-babel'),
	traceur = require('gulp-traceur'),
	es6Path = 'es6/*.js',
	compilePath = 'es5';

gulp.task('traceur', function () {
	gulp.src([es6Path])
		.pipe(traceur({blockBinding:true}))
		.pipe(gulp.dest(compilePath+ '/traceur'));
});

gulp.task('babel', function () {
	gulp.src([es6Path])
		.pipe(babel({presets:['es2015']}))
		.pipe(gulp.dest(compilePath+ '/babel'));
});

gulp.task('watch', function () {
	gulp.watch([es6Path], ['traceur','babel','watch']);
});

gulp.task('default',['traceur', 'babel', 'watch']);