'use strict';

var gulp   = require('gulp');
var gutil   = require('gulp-util');
var coffee = require('gulp-coffee');
// var jshint = require('gulp-jshint');
// var summary   = require('jshint-summary');
var mocha  = require('gulp-mocha');
var bump = require('gulp-bump');



// e.g. gulp bump --type minor
gulp.task('bump', function(){
  return gulp.src('./package.json')
  .pipe(bump({ type: gulp.env.type || 'patch' }))
  .pipe(gulp.dest('./'));
});


gulp.task('coffee', function() {
  gulp.src('./src/**/*.coffee')
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./lib'));
});


// gulp.task('lint', function () {
//   return gulp.src('./lib/*.js')
//     .pipe(jshint('.jshintrc'))
//     .pipe(jshint.reporter(summary({
//       statistics: false,
//       unicode: true
//     })));
// });


gulp.task('mocha', function () {
  return gulp.src('./test/**/*.js')
    .pipe(mocha({
      reporter: 'html-cov'
    }));
});

gulp.task('test', ['mocha']);


gulp.task('watch', ['test'], function() {
  gulp.watch('./**/*.coffee', ['coffee']);
  gulp.watch(['./lib/**/*.js', './test/*.js'], ['test']);
});


gulp.task('default', ['watch']);

