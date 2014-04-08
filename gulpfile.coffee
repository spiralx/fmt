
gulp   = require 'gulp'
gutil   = require 'gulp-util'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
# summary   = require 'jshint-summary'
mocha  = require 'gulp-mocha'



# e.g. gulp bump --type minor
gulp.task 'bump', ->
  gulp.src './package.json'
    .pipe bump { type: gulp.env.type || 'patch' }
    .pipe gulp.dest './'



gulp.task 'coffee', ->
  coff = coffee({
      bare: true
    })
    .on 'error', gutil.log

  gulp.src './src/**/*.coffee'
    .pipe coff
    .pipe gulp.dest './lib'

  # gulp.src './test/**/*.coffee'
  #   .pipe coff
  #   .pipe gulp.dest './test'



gulp.task 'lint', ->
  gulp.src './src/*.coffee'
    .pipe coffeelint()
    .pipe coffeelint.reporter()



gulp.task 'mocha', ['coffee'], ->
  gulp.src './test/**/*.coffee'
    .pipe mocha {
      reporter: 'spec'
    }


gulp.task 'test', ['lint', 'mocha']

gulp.task 'build', ['coffee', 'test']

gulp.task 'watch', ['test'], ->
  gulp.watch './**/*.coffee', ['coffee']
  gulp.watch ['./lib/**/*.js', './test/*.js'], ['test']



gulp.task 'default', ['build']

